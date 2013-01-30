if !has('python')
    echo "Error: Required vim compiled with +python"
    finish
endif

python << endpython
try:
    def _how_do_i(args=None):
        import vim
        import requests
        import json

        search_url = "https://api.stackexchange.com/2.0/similar?order=desc&sort=relevance&title=%s&site=stackoverflow"
        answer_url = "https://api.stackexchange.com/2.0/answers/%s?order=desc&sort=activity&site=stackoverflow&filter=!))aJblQ"

        title = args.replace(' ', '%20')+'in%20vim'
        r = requests.get(search_url % title)
        results = [res for res in json.loads(r.content)['items'] if 'accepted_answer_id' in res]
        for result in results[0:3]:
            answer_id = result['accepted_answer_id']
            answer_json = json.loads(requests.get(answer_url % answer_id).content)
            top_answer = answer_json['items'][0]['body']
            top_answer = top_answer.replace("<p>", "").replace("</p>","").replace("&lt;","<")
            top_answer = top_answer.replace("&gt;",">").replace("<code>","`").replace("</code>","`")
            top_answer = top_answer.replace("\n", " ").replace("<pre>", "").replace("</pre>","")
            print result['title'], "\n    " + top_answer
except Exception, e:
    print exception

endpython
command -nargs=* HowDoI :python _how_do_i(<args>)
