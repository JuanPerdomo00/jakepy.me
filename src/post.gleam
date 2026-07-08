import mork
import simplifile

pub type Post {
  Post(slug: String, title: String, date: String, content: String)
}

fn read_content_md(path: String) -> String {
  case simplifile.read(path) {
    Ok(markdown) -> markdown |> mork.parse |> mork.to_html
    Error(_) -> ""
  }
}

pub fn all_posts() -> List(Post) {
  [
    Post(
      slug: "1-memoria-en-zig",
      title: "Memoria en Zig",
      date: "06 nov 2025",
      content: read_content_md("content/1-memoria-en-zig.md"),
    ),
    Post(
      slug: "2-memoria-en-rust",
      title: "Memoria en Rust",
      date: "21 nov 2025",
      content: read_content_md("content/2-memoria-en-rust.md"),
    ),
    Post(
      slug: "3-porque-755",
      title: "Porque 755",
      date: "17 Ene 2026",
      content: read_content_md("content/3-porque_755.md"),
    ),
  ]
}
