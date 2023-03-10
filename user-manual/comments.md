# Comments

#### Nested Routes

When you read a post at /posts/:id and press the comment button, the page will route to /posts/:id/comments (this route is [nested](https://www.robinwieruch.de/react-router-nested-routes/)), and will smoothly auto-scroll to the comments section below the post.

<figure><img src="../.gitbook/assets/image (4).png" alt=""><figcaption></figcaption></figure>

#### Edit / Delete Comments

You can edit or delete comments written by yourself. For example, by pressing the "Edit" icon, you would be able to edit the comment, and you can click the "Cancel" button to render the comment view again:

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption></figcaption></figure>

By clicking the "delete" icon, we will ask you to confirm that you really wish to delete this comment, as deleted comments cannot be recovered \[The same procedure also applies for topics and posts]:&#x20;

<figure><img src="../.gitbook/assets/image (17).png" alt=""><figcaption></figcaption></figure>
