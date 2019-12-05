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
        return self.to_candidates(self.vim.call('vsnip#source#find', context['filetype']))

    def to_candidates(self, sources):
        candidates = []

        for source in sources:
            for snippet in source:
                for prefix in snippet['prefix']:
                    candidate = {
                        'word': prefix,
                        'abbr': prefix,
                        'menu': 'Snippet',
                        'info': snippet['label']
                    }
                    if 'description' in snippet and len(snippet['description']) > 0:
                        candidate['info'] += ': {}'.format(snippet['description'])
                    candidates.append(candidate)

        return candidates

