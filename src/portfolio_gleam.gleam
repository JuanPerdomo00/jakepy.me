import gleam/list
import post
import simplifile
import views

pub fn main() {
  simplifile.create_directory_all("dist/post")
  simplifile.create_directory_all("dist/static")

  let posts = post.all_posts()
  list.each(posts, views.write_post)
  views.write_home()
  views.write_post_list(posts)
  views.copy_static()
}
