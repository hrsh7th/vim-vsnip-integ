import json
from deoplete.source.base import Base

class Source(Base):
    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'vsnip'
        self.mark = '[vsnip]'
        self.rank = 1000
        self.input_pattern = r'\w\+$'
        self.min_pattern_length = 1
        self.vars = {}

    def gather_candidates(self, context):
        return self.vim.call('vsnip#get_complete_items', context['bufnr'])

