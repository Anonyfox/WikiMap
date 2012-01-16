Shoes.setup do
  gem 'chunky_png'
end

require 'chunky_png'

Shoes.app do
  stack do
    @from = para "choose..."
    button("choose"){
      source = ask_open_file
      path = source.split("/")[0..-2].join("/") + "/"
      png = ChunkyPNG::Image.from_file(source)
      png.crop 0, 0, 50, 50
      png.save path + "thumb.png"
    }
  end
end