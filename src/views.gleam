import gleam/io
import gleam/list
import gleam/string
import post.{type Post}
import simplifile

pub fn write_home() {
  let html = render_home()
  let path = "dist/index.html"
  simplifile.write(path, html)
}

pub fn copy_static() {
  simplifile.copy_directory("static", "dist/static")
}

pub fn write_post_list(posts: List(Post)) {
  let html = render_post_list(posts)
  simplifile.write("dist/post/post.html", html)
}

pub fn write_post(p: Post) {
  let html = render_post(p)
  let path = "dist/post/" <> p.slug <> ".html"
  case simplifile.write(path, html) {
    Ok(_) -> Nil
    Error(e) ->
      io.println("Error write post " <> path <> ": " <> string.inspect(e))
  }
}

pub fn render_home() -> String {
  "<!DOCTYPE html>
<html lang=\"es\">
<head>
  <meta charset=\"UTF-8\" />
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
  <title>Jakepys | Portfolio</title>
  <link rel=\"stylesheet\" href=\"/static/style.css\" />
</head>
<body class=\"min-h-screen flex flex-col bg-[#1a1b26] text-[#c0caf5] font-[\\'IosevkaNerdFontMono\\'] max-w-2xl mx-auto px-6 py-16\">
  <header class=\"mb-12\">
    <div id=\"presentation\" class=\"mb-6\">
      <img id=\"imgjakepys\" src=\"/static/img/profile.jpg\" alt=\"Jakepys\" class=\"w-24 h-24 rounded-full object-cover mb-4 border-2 border-[#ffaff3]\">
      <h1 class=\"text-3xl font-bold text-[#ffaff3] font-[\\'IosevkaNerdFontMono\\']\">Juan Perdomo <span id=\"nick\" class=\"text-[#7dcfff]\">(Jakepys)</span></h1>
      <p class=\"text-[#c0caf5] mt-2\">I'm a software developer and I like to take things apart to learn how they're built.</p>
    </div>
    <nav class=\"flex gap-4 text-sm\">
      <a href=\"mailto:perdomojuan187@gmail.com\" class=\"text-[#7dcfff] hover:text-[#ffaff3] transition-colors\">Email</a>
      <a href=\"https://github.com/JuanPerdomo00\" target=\"_blank\" class=\"text-[#7dcfff] hover:text-[#ffaff3] transition-colors\">Github</a>
      <a href=\"/post/post.html\" class=\"text-[#7dcfff] hover:text-[#ffaff3] transition-colors\">Posts</a>
      <a href=\"/mirrors.txt\" class=\"text-[#7dcfff] hover:text-[#ffaff3] transition-colors\">Mirrors</a>
    </nav>
    <div id=\"player\" class=\"fixed bottom-6 right-6 flex flex-col items-center justify-center gap-2 w-32 h-32 bg-[#16161e] border border-[#292e42] rounded-xl shadow-lg z-50 p-4\">
  <span class=\"text-[#565f89] text-[10px] text-center leading-tight\">koi wo shita nowa</span>
  <div class=\"flex items-center gap-3\">
    <button id=\"play-btn\" class=\"text-[#ffaff3] hover:text-[#7dcfff] transition-colors text-3xl\"></button>
    <button id=\"mute-btn\" class=\"text-[#7dcfff] hover:text-[#ffaff3] transition-colors text-xl\"></button>
  </div>
  <audio id=\"bg-audio\" src=\"/static/audio/koi-wo-shita-nowa.mp3\" loop></audio>
</div>
    </header>
  <main class=\"flex-1 mb-16\">
    <p class=\"simple-text text-[#565f89] mb-8\">
      If you want to know more about me, well, my GitHub is part of my life, or something like that.
    </p>
  <div class=\"mt-6\">
  <p class=\"text-[#565f89] text-xs mb-2\">Stack</p>
  <div class=\"flex items-center gap-2 flex-wrap\">
    <img src=\"https://skillicons.dev/icons?i=c,rust,py,js&theme=dark\" alt=\"C, Rust, Python, JavaScript\" class=\"h-10\" />
    <img src=\"https://img.shields.io/badge/Gleam-ffaff3?style=for-the-badge&logo=gleam&logoColor=1a1b26\" alt=\"Gleam\" class=\"h-6\" />
  </div>
</div>

<div class=\"mt-4\">
  <p class=\"text-[#565f89] text-xs mb-2\">tools</p>
  <div class=\"flex items-center gap-2\">
    <img src=\"https://skillicons.dev/icons?i=arch,git&theme=dark\" alt=\"Arch Linux, Git\" class=\"h-10\" />
    <span class=\"text-[#7dcfff] text-xs\">I use artix btw</span>
  </div>
  <div class=\"mt-4\">
  <p class=\"text-[#565f89] text-xs mb-2\">favorite editor</p>
  <img src=\"https://skillicons.dev/icons?i=neovim,vscode&theme=dark\" alt=\"Neovim, VSCode\" class=\"h-10\" />
</div>
</div>
  </main>
  <footer class=\"text-[#565f89] text-xs border-t border-[#292e42] pt-6\">
    Made with love and <a href=\"https://gleam.run\" target=\"_blank\" class=\"text-[#ffaff3] hover:underline\">Gleam</a> ✨
  </footer>
  <script src=\"/static/oneko.js\" data-cat=\"/static/oneko.gif\"></script>
  <script src=\"/static/radom_char.js\"></script>
  <script src=\"/static/audio-player.js\"></script>
</body>
</html>"
}

pub fn render_post_list(posts: List(Post)) -> String {
  let post_links =
    posts
    |> list.map(fn(p) {
      "<li><a href=\"/post/"
      <> p.slug
      <> ".html\" class=\"text-[#c0caf5] hover:text-[#ffaff3] transition-colors underline underline-offset-4 decoration-[#565f89]\">"
      <> p.title
      <> "</a> <span class=\"text-[#565f89] text-sm\">— "
      <> p.date
      <> "</span></li>"
    })
    |> string.join("\n")
  "<!DOCTYPE html>
<html lang=\"es\">
<head>
  <meta charset=\"UTF-8\" />
  <title>Posts | Jakepys</title>
  <link rel=\"stylesheet\" href=\"/static/style.css\" />
</head>
<body class=\"min-h-screen flex flex-col bg-[#1a1b26] text-[#c0caf5] font-[\\'Source_Code_Pro\\'] max-w-2xl mx-auto px-6 py-16\">
  <a href=\"/\" class=\"text-[#7dcfff] hover:text-[#ffaff3] transition-colors text-sm\">&larr; back</a>
  <main class=\"flex-1 mt-6\">
    <h1 class=\"text-2xl font-bold text-[#ffaff3] mb-6\">Posts</h1>
    <ul class=\"space-y-3\">
      " <> post_links <> "
    </ul>
  </main>
  <footer class=\"text-[#565f89] text-xs border-t border-[#292e42] pt-6 mt-16\">
    Made with love and <a href=\"https://gleam.run\" target=\"_blank\" class=\"text-[#ffaff3] hover:underline\">Gleam</a> ✨
  </footer>
</body>
</html>"
}

pub fn render_post(p: Post) -> String {
  "<!DOCTYPE html>
<html lang=\"es\">
<head>
  <meta charset=\"UTF-8\" />
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />
  <title>" <> p.title <> " | Jakepys</title>
  <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">
  <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>
  <link href=\"https://fonts.googleapis.com/css2?family=SUSE+Mono:wght@400;700&family=Source+Code+Pro:wght@400;700&display=swap\" rel=\"stylesheet\">
  <link rel=\"stylesheet\" href=\"/static/style.css\" />
</head>
<body class=\"min-h-screen flex flex-col bg-[#1a1b26] text-[#c0caf5] font-[\\'Source_Code_Pro\\'] max-w-2xl mx-auto px-6 py-16\">
  <a href=\"/\" class=\"text-[#7dcfff] hover:text-[#ffaff3] transition-colors text-sm\">&larr; back</a>
  <main class=\"flex-1 mt-6\">
    <h1 class=\"text-3xl font-bold text-[#ffaff3] font-[\\'SUSE_Mono\\'] mb-2\">" <> p.title <> "</h1>
    <p class=\"text-[#565f89] text-sm mb-8\">" <> p.date <> "</p>
    <div class=\"content prose-invert leading-relaxed\">" <> p.content <> "</div>
  </main>
  <footer class=\"text-[#565f89] text-xs border-t border-[#292e42] pt-6 mt-16\">
    Made with love and <a href=\"https://gleam.run\" target=\"_blank\" class=\"text-[#ffaff3] hover:underline\">Gleam</a> ✨
  </footer>
</body>
</html>"
}
