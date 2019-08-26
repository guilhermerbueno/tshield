# frozen_string_literal: true

require 'spec_helper'

require 'tshield/configuration'
require 'tshield/request_matching'
require 'tshield/response'

describe TShield::RequestMatching do
  before :each do
    @configuration = double
    allow(TShield::Configuration)
      .to receive(:singleton).and_return(@configuration)
  end

  context 'matching path' do
    before :each do
      allow(Dir).to receive(:glob)
        .and_return(['spec/tshield/fixtures/matching/example.json'])
    end

    context 'on loading stubs' do
      before :each do
        @request_matching = TShield::RequestMatching.new('/')
      end
      context 'for path /matching/example' do
        it 'should map path' do
          expect(@request_matching.class.stubs[DEFAULT_SESSION]).to include('/matching/example')
        end
        context 'on settings' do
          before :each do
            @entry = @request_matching.class.stubs[DEFAULT_SESSION]['/matching/example'][0]
          end
          it 'should answer for the method GET' do
            expect(@entry['method']).to include('GET')
          end
          it 'should have response body' do
            expect(@entry['response']['body']).to include('query content')
          end
        end
      end
    end

    context 'on matching request' do
      context 'on match' do
        before :each do
          @request_matching = TShield::RequestMatching.new('/matching/example', method: 'GET')
        end
        it 'should return response object' do
          @response = @request_matching.match_request
          expect(@response.body).to eql('body content')
          expect(@response.headers).to eql({})
          expect(@response.status).to eql(200)
        end
      end
      context 'on match by path and method' do
        before :each do
          @request_matching = TShield::RequestMatching
                              .new('/matching/example', method: 'POST')
        end
        it 'should return response object' do
          @response = @request_matching.match_request
          expect(@response.body).to eql('post content')
          expect(@response.headers).to eql({})
          expect(@response.status).to eql(201)
        end
      end
      context 'on match by path and method and headers' do
        before :each do
          @request_matching = TShield::RequestMatching
                              .new('/matching/example',
                                   method: 'POST',
                                   headers: { 'HTTP_HEADER1' => 'value' })
        end
        it 'should return response object' do
          @response = @request_matching.match_request
          expect(@response.body).to eql('headers content')
          expect(@response.headers).to eql({})
          expect(@response.status).to eql(201)
        end
      end
      context 'on match by path and method and query' do
        before :each do
          @request_matching = TShield::RequestMatching
                              .new('/matching/example',
                                   method: 'GET',
                                   raw_query: 'query1=value')
        end
        it 'should return response object' do
          @response = @request_matching.match_request
          expect(@response.body).to eql('query content')
          expect(@response.headers).to eql({})
          expect(@response.status).to eql(200)
        end
      end
      context 'on not match' do
        before :each do
          @request_matching = TShield::RequestMatching.new('/')
        end
        it 'should return nil' do
          expect(@request_matching.match_request).to be_nil
        end
      end
    end
    context 'on session' do
      context 'load session infos' do
        before :each do
          @request_matching = TShield::RequestMatching.new('/')
        end

        it 'should map path' do
          expect(@request_matching.class.stubs['a-session']).to include('/matching/example')
        end
      end
    end
  end
end
