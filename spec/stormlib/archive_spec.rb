# frozen_string_literal: true

RSpec.describe StormLib::Archive do
  let(:test_file_content) { 'Hello, World!' }
  let(:test_file_name) { 'test.txt' }
  let(:archived_file_name) { 'archived_test.txt' }

  around(:each) do |example|
    Dir.mktmpdir do |tmp_dir|
      @test_mpq_path = File.join(tmp_dir, 'test.mpq')

      archive = StormLib::Archive.new(@test_mpq_path, create: true)

      Tempfile.create(test_file_name) do |file|
        file.write(test_file_content)
        file.flush
        archive.add_file(file.path, archived_file_name)
      end

      archive.close

      example.run
    end
  end

  describe '#initialize' do
    it 'creates a new archive' do
      Tempfile.create(%w[new .mpq]) do |file|
        expect { StormLib::Archive.new(file.path, create: true) }.not_to raise_error
      end
    end

    it 'opens an existing archive' do
      expect { StormLib::Archive.new(@test_mpq_path) }.not_to raise_error
    end
  end

  describe '#add_file' do
    it 'adds a file to the archive' do
      Tempfile.create(%w[new .mpq]) do |mpq_file|
        archive = StormLib::Archive.new(mpq_file.path, create: true)

        Tempfile.create('new_file') do |file|
          file.write('New content')
          file.flush
          expect(archive.add_file(file.path, 'new_archived_file.txt')).to be true
        end

        archive.close
      end
    end
  end

  describe '#extract_file' do
    it 'extracts a file from the archive' do
      archive = StormLib::Archive.new(@test_mpq_path)

      Tempfile.create('extracted') do |file|
        expect(archive.extract_file(archived_file_name, file.path)).to be true
        expect(File.read(file.path)).to eq(test_file_content)
      end

      archive.close
    end
  end

  describe '#close' do
    it 'closes the archive without errors' do
      archive = StormLib::Archive.new(@test_mpq_path)
      expect { archive.close }.not_to raise_error
    end
  end
end
