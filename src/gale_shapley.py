from MP_SPDZ.Compiler import types

from MP_SPDZ.Compiler.util import *

from MP_SPDZ.Compiler.oram import OptimalORAM

from MP_SPDZ.Compiler.library import for_range, do_while, time, \
    if_, print_ln, crash, print_str
from MP_SPDZ.Compiler.gs import OMatrix, OStack


class Matchmaker:
    """
    Makes self.f_ranks and self.m_prefs as instances of OMatrix
    We can call them p_cases (patient cases) and t_exps (therapist experience)
    """

    def init_easy(self):
        self.m_prefs = OMatrix(self.N, self.M, oram_type=self.oram_type, \
                                   int_type=self.int_type)
        @for_range(self.N)
        def f(i):
            time()
            types.cint(i).print_reg('mpre')
            @for_range(self.M)
            def f(j):
                self.m_prefs[i][j] = (i + j) % self.N

        self.f_ranks = OMatrix(self.N, oram_type=self.oram_type, \
                                   int_type=self.int_type)
        @for_range(self.N)
        def f(i):
            time()
            types.cint(i).print_reg('fran')
            @for_range(self.M)
            def f(j):
                self.f_ranks[i][(j-i+self.N)%self.N] = j

    def engage(self, man, woman, for_real):
        self.wives.access(man, woman, for_real)
        # self.husbands.ram[0].x[0].reveal().print_reg('a')
        self.husbands.access(woman, man, for_real)
        # self.husbands.ram[0].x[0].reveal().print_reg('b')
        # (man * 10 + woman * 1 + for_real * 100).reveal().print_reg('eng')
        # if for_real:
        #     print 'engage', man, woman
        #     self.wives[man] = woman
        #     self.husbands[woman] = man

    def dump(self, man, woman, for_real):
        self.wives.delete(man, for_real)
        # self.husbands.ram[0].x[0].reveal().print_reg('c')
        self.husbands.delete(woman, for_real)
        # self.husbands.ram[0].x[0].reveal().print_reg('d')
        self.unengaged.append(man, for_real)
        # self.husbands.ram[0].x[0].reveal().print_reg('e')
        # (man * 10 + woman + for_real * 100).reveal().print_reg('dump')
        # if for_real:
        #     print 'dump', man, woman
        #     self.wives[man] = clown
        #     self.husbands[woman] = clown

    def propose(self, man, woman, for_real):
        (fiance,), free = self.husbands.read(woman)
        # self.husbands.ram[0].x[0].reveal().print_reg('f')
        engaged = 1 - free
        rank_man = self.f_ranks[woman][man]
        # self.husbands.ram[0].x[0].reveal().print_reg('g')
        (rank_fiance,), worst_fiance = self.f_ranks[woman].read(engaged*fiance)
        # self.husbands.ram[0].x[0].reveal().print_reg('h')
        leaving = self.int_type(rank_man) < self.int_type(rank_fiance)
        if self.M < self.N:
            leaving = 1 - (1 - leaving) * (1 - worst_fiance)
        print_str('woman: %s, man: %s, fiance: %s, worst fiance: %s, ', \
                     *(x.reveal() for x in (woman, man, fiance, worst_fiance)))
        print_ln('rank man: %s, rank fiance: %s, engaged: %s, leaving: %s', \
                     *(x.reveal() for x in \
                           (rank_man, rank_fiance, engaged, leaving)))
        self.dump(fiance, woman, engaged * leaving * for_real)
        self.engage(man, woman, (1 - (engaged * (1 - leaving))) * for_real)
        self.unengaged.append(man, engaged * (1 - leaving) * for_real)
        # self.husbands.ram[0].x[0].reveal().print_reg('i')

    def match(self, n_loops=None):
        if n_loops is None or n_loops > self.N * self.M:
            loop = do_while
            init_rounds = self.N
        else:
            loop = for_range(n_loops)
            init_rounds = n_loops / self.M
        self.wives = \
            self.oram_type(self.N, entry_size=log2(self.N), \
                               init_rounds=0, value_type=self.basic_type)
        self.husbands = \
            self.oram_type(self.N, entry_size=log2(self.N), \
                               init_rounds=0, value_type=self.basic_type)
        propose = \
            self.oram_type(self.N, entry_size=log2(self.N), \
                               init_rounds=0, value_type=self.basic_type)
        self.unengaged = OStack(self.N, oram_type=self.oram_type, \
                                    int_type=self.int_type)
        @for_range(init_rounds)
        def f(i):
            self.unengaged.append(i)
        rounds = types.MemValue(types.regint(0))
        @loop
        def f(i=None):
            rounds.iadd(1)
            time()
            man = self.unengaged.pop()
            # self.husbands.ram[0].x[0].reveal().print_reg('j')
            pref = self.int_type(propose[man])
            if self.M < self.N and n_loops is None:
                @if_((pref == self.M).reveal())
                def f():
                    print_ln('run out of acceptable women')
                    crash()
            # self.husbands.ram[0].x[0].reveal().print_reg('k')
            propose[man] = pref + 1
            # self.husbands.ram[0].x[0].reveal().print_reg('l')
            self.propose(man, self.m_prefs[man][pref], True)
            print_ln('man: %s, pref: %s, left: %s', \
                         *(x.reveal() for x in (man, pref, self.unengaged.size)))
            # self.wives[man].reveal().print_reg('wife')
            return types.regint((self.unengaged.size > 0).reveal())
        print_ln('%s rounds', rounds)
        @for_range(init_rounds)
        def f(i):
            types.cint(i).print_reg('wife')
            self.husbands[i].reveal().print_reg('husb')

    def __init__(self, N, M=None, reverse=False, oram_type=OptimalORAM, \
                     int_type=types.sint):
        self.N = N
        self.M = N if M is None else M
        self.oram_type = oram_type
        self.reverse = reverse
        self.int_type = int_type
        self.basic_type = int_type.basic_type
        print('match', self.oram_type)
