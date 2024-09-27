<div class="mt-4">
  <form action="/blogs" method="POST">
    <div class="grid grid-flow-dense grid-cols-4 gap-4">
      <label>Title</label>
      <div class="col-span-3 mt-3">
        <input class="border p-1" type="text" name="title" />
      </div>

      <label>Content</label>
      <div class="col-span-3 mt-3">
        <textarea class="border p-1" cols="30" rows="10" name="content" placeholder="Enter content here"></textarea>
      </div>
    </div>

    <input class="border py-1 px-2 bg-[#f7931e] text-white" type="submit" value="Submit" />
  </form>
</div>