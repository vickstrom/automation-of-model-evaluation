Finally, we can assemble everything to evaluate a model from a certain pull request and send the results! If we would like, we could also format our message to make them more readable, kind of like this: 

| Source| Loss           | Accuracy            |
| ------| ---------------| ------------------- |
| Head  | 1.07 | 78.0% |
| Base  | 1.06 | 80.0% |
| Diff  | 0.01    | -2.0%         |

Let's create a utility function that creates a Markdown table with the data based on the `loss` and `accuracy` from what the pull request contains (_head_) and to where it's going (_base_). 

<pre class="file">
# ...
def format_markdown_comment(head, base):
    diff_loss = round(head['loss'] - base['loss'], 2)
    diff_acc = round(head['accuracy'] - base['accuracy'], 2)
    rows = [
        f"| Source| Loss           | Accuracy            |",
        f"| ------| ---------------| ------------------- |",
        f"| Head  | {head['loss']} | {head['accuracy']}% |",
        f"| Base  | {base['loss']} | {base['accuracy']}% |",
        f"| Diff  | {diff_loss}    | {diff_acc}%         |"
    ]
    return "\n".join(rows)
# ...
</pre>

Now, add these to the `mlops_server_endpoint()`.

<pre class="file">
# ...
@app.route('/mlops-server', methods=['POST'])
def mlops_server_endpoint():
    response = request.get_json()

    if is_valid_response(response):
        sha_head, sha_base = get_commits(response)
        comments_url, url_head, url_base = get_urls(response)

        head_result = evaluate_pull_request(sha_head, url_head)
        base_result = evaluate_pull_request(sha_base, url_base)

        message = format_markdown_comment(head_result, base_result)

        token = get_token()
        post_message_on_pull_request(comments_url, token, message)
    return 'Awaiting POST'
# ...
</pre>
