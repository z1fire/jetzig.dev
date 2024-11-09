<div>
  @partial blogs/title(.blog.title, .blog.author)

  <div>
    {{zmpl.fmt.raw(zmpl.ref("blog.content"))}}
  </div>

  @for (.blog.comments) |comment| {
    @partial blogs/comment(comment.name, comment.content)
  }

  <div class="grid grid-flow-dense grid-cols-4 gap-4">
    <form action="/blogs/comments" method="POST">
      <input type="hidden" name="blog_id" value="{{.blog.id}}" />
      <input type="text" name="name" placeholder="Your name here" />
      <textarea name="content" placeholder="Enter comment here..."></textarea>
      <input class="border py-1 px-2 bg-[#f7931e] text-white" type="submit" value="Submit" />
    </form>
  </div>
</div>
