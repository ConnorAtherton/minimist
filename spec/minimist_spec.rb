require 'spec_helper'

describe Minimist do
  it 'has a version number' do
    expect(Minimist::VERSION).not_to be nil
  end

  it 'returns a hash result' do
    result = parse('')

    expect(result).to be_instance_of(Hash)
  end

  it 'splits arguments into commands and options' do
    result = parse('')

    expect(result).to satisfy do
      result.keys.length == 2 && result[:commands] && result[:options]
    end
  end

  it 'parses commands correctly' do
    result = parse('do command')

    expect(result[:commands]).to contain_exactly('do', 'command')
  end

  it 'parses multiple single dash arguments correctly' do
    result = parse('-abc')

    expect(result[:options]).to eql(
      a: true,
      b: true,
      c: true
    )
  end

  it 'parses single dash with a value correctly' do
    result = parse('-a4')

    expect(result[:options]).to eql(a: '4')
  end

  it 'parses double dash arguments with no value' do
    result = parse('--change')

    expect(result[:options]).to eql(change: true)
  end

  it 'parses double dash arguments with a next value' do
    result = parse('--change urgent')

    expect(result[:options]).to eql(change: 'urgent')
  end

  it 'parses double dash arguments with a value set with =' do
    result = parse('--change=urgent')

    expect(result[:options]).to eql(change: 'urgent')
  end

  it 'parses double dash negation arguments' do
    result = parse('--no-change')

    expect(result[:options]).to eql(change: false)
  end

  it 'converts all dashes into underscore' do
    result = parse('--dry-run')

    expect(result[:options]).to eql(dry_run: true)
  end
end
