require_relative '../receive/attachments_helper.rb'


describe '#parse_attached_images' do

  it 'does nothing when there are no attachments' do
    payload = "[]"
    expect(parse_attached_images(payload)).to eq([])
  end

  it 'returns only image attachments' do
    payload = <<-JSON
      [
        {
          "size": 2048,
          "name": "x.png",
          "url": "http://x.net/caff0x00",
          "content-type": "image/jpeg"
        },
        {
          "size": 4096,
          "name": "y.jpg",
          "url": "http://y.org/6832476234234234",
          "content-type": "image/png"
        },
        {
          "size": 290413,
          "name": "pg48734.txt",
          "url": "https://www.gutenberg.org/cache/epub/48734/pg48734.txt",
          "content-type": "text/plain"
        },
        {
          "size": 10819304,
          "name": "windows.exe",
          "url": "http://microsoft.com/en/downloads/3.11",
          "content-type": "application/x-msdownload"
        }
      ]
    JSON
    expected = [
      {
        "size" => 2048,
        "name" => "x.png",
        "url" => "http://x.net/caff0x00",
        "content-type" => "image/jpeg"
      },
      {
        "size" => 4096,
        "name" => "y.jpg",
        "url" => "http://y.org/6832476234234234",
        "content-type" => "image/png"
      },
    ]

    expect(parse_attached_images(payload)).to eq(expected)
  end
end
