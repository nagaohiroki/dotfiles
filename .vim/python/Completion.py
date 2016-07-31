import vim, syncrequest, types
class Completion:
    def get_completions(self, column, partialWord):
        parameters = {}
        parameters['column'] = vim.eval(column)
        parameters['wordToComplete'] = vim.eval(partialWord)

        parameters['WantDocumentationForEveryCompletionResult'] = \
            bool(int(vim.eval('g:omnicomplete_fetch_full_documentation')))

        textBuffer = '\r\n'.join(vim.eval('s:textBuffer')[:])
        enc = vim.eval('&encoding')
        parameters['buffer'] = textBuffer.decode(enc).encode("utf-8")
        response = syncrequest.get_response('/autocomplete', parameters)


        vim_completions = []
        if response is not None:
            for completion in response:
                complete = {
                    'snip': completion['Snippet'] or '',
                    'word': completion['MethodHeader'] or completion['CompletionText'],
                    'menu': completion['ReturnType'] or completion['DisplayText'],
                    'info': (completion['Description'] or '').replace('\r\n', '\n'),
                    'icase': 1,
                    'dup':1
                }
                vim_completions.append(complete)

        return vim_completions
