require_relative '../../process/resize_job'

describe ResizeJob do
  let(:sender) { 'fredrik@mollerstrand.se' }
  let(:attachment) {
    {
      'size' => 1024,
      'url' => 'https://gun.com/xyz',
      'name' => 'kanagawa.jpg',
      'content-type' => 'image/jpeg'
    }
  }

  it 'resizes an image', type: :integration do
    resized_image = double
    now = double
    allow(Time).to receive(:now).and_return(now)
    allow(SecureRandom).to receive(:hex).and_return('d00d')
    allow(ImageFetcher).to receive(:fetch).with('https://gun.com/xyz', 'api', 'xyz')
                       .and_return('a-binary-blob')
    allow(Resizer).to receive(:resize) .with('a-binary-blob')
                  .and_return(resized_image)
    allow(Image).to receive(:create).with({
                  sender: sender, filename: 'd00d',
                  content_type: 'image/jpeg', created_at: now
                })
    expect(resized_image).to receive(:write).with('/tmp/resize_test/d00d')

    expect(ResizeJob.perform(sender, attachment)).to eq(true)
  end

end
