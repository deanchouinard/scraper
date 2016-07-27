defmodule Scraper do
  use Hound.Helpers

  def start do
    IO.puts "starting"
    Hound.start_session
    navigate_to "https://example.com/login"
    find_element(:id, "user_login") |> fill_field('deanc')
    el = find_element(:id, "user_pass")
    fill_field(el, 'passwordblah')
    submit_element(el)
  end

  def download(src, output_filename) do
    IO.puts "Downloading #{src} -> #{output_filename}"
    #body = HTTPoison.get!(src).body
    body = HTTPoison.get!(src).body
    File.write!(output_filename, body)
    IO.puts "Done downloading #{src} -> #{output_filename}"
  end

  def get_video(url, output_filename) do
    navigate_to url
    page_source() |> Floki.find("source") |> Floki.attribute("src")
      |> IO.inspect |> download(output_filename)
  end
  
  def get_video_sp(url, output_filename) do
    navigate_to url
    #video_src = page_source() |> Floki.find("source") |> Floki.attribute("src")
    video_src = page_source()
    spawn(Scraper, :download, [video_src, output_filename])

    #  |> IO.inspect |> download(output_filename)
  end

  defp pb_user do
    Application.get_env(:scraper, :user)
  end

end
