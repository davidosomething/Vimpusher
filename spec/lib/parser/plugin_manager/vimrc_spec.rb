require 'spec_helper'
require 'parser/plugin_manager/vimrc'

describe Parser::PluginManager::Vimrc do

  describe '#parse' do
    subject { Parser::PluginManager::Vimrc }

    context "Common case" do
      it { subject.parse("   filetype on        \" enable filetype detection").should be_nil }
      it { subject.parse("\" Formatting {{{").should be_nil }
      it { subject.parse("\" Bundle 'tpope/vim-rails'").should be_nil }
    end

    context "for Vundle" do
      context "original repos on github" do
        it { subject.parse("      Bundle 'gmarik/vundle'").should                     == "gmarik/vundle" }
        it { subject.parse("      Bundle 'tpope/vim-fugitive'").should                == "tpope/vim-fugitive" }
        it { subject.parse("      Bundle 'Lokaltog/vim-easymotion'").should           == "Lokaltog/vim-easymotion" }
        it { subject.parse("      Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}").should == "rstacruz/sparkup" }
        it { subject.parse("      Bundle 'tpope/vim-rails.git'").should               == "tpope/vim-rails" }
      end

      context "vim-scripts repos" do
        it { subject.parse("      Bundle 'L9'").should          == "L9" }
        it { subject.parse("      Bundle 'FuzzyFinder'").should == "FuzzyFinder" }
      end

      context "non github repos" do
        it { subject.parse("     Bundle 'git://git.wincent.com/command-t.git'").should == "git.wincent.com/command-t.git" }
      end

      context "start with no space" do
        it { subject.parse("Bundle 'gmarik/vundle'").should == "gmarik/vundle" }
      end

      context "double quotation" do
        it { subject.parse("Bundle \"gmarik/vundle\"").should == "gmarik/vundle" }
      end
    end

    context "for neobundle" do
      context "original repos on github" do
        it { subject.parse("      NeoBundle 'gmarik/vundle'").should                     == "gmarik/vundle" }
        it { subject.parse("      NeoBundle 'tpope/vim-fugitive'").should                == "tpope/vim-fugitive" }
        it { subject.parse("      NeoBundle 'Lokaltog/vim-easymotion'").should           == "Lokaltog/vim-easymotion" }
        it { subject.parse("      NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}").should == "rstacruz/sparkup" }
        it { subject.parse("      NeoBundle 'tpope/vim-rails.git'").should               == "tpope/vim-rails" }
      end

      context "vim-scripts repos" do
        it { subject.parse("      NeoBundle 'L9'").should          == "L9" }
        it { subject.parse("      NeoBundle 'FuzzyFinder'").should == "FuzzyFinder" }
      end

      context "non github repos" do
        it { subject.parse("     NeoBundle 'git://git.wincent.com/command-t.git'").should                        == "git.wincent.com/command-t.git" }
        it { subject.parse("     NeoBundle 'http://svn.macports.org/repository/macports/contrib/mpvim/'").should == "svn.macports.org/repository/macports/contrib/mpvim" }
        it { subject.parse("     NeoBundle 'https://bitbucket.org/ns9tks/vim-fuzzyfinder'").should               == "bitbucket.org/ns9tks/vim-fuzzyfinder" }
      end

      context "start with no space" do
        it { subject.parse("NeoBundle 'gmarik/vundle'").should == "gmarik/vundle" }
      end

      context "double quotation" do
        it { subject.parse("NeoBundle \"gmarik/vundle\"").should == "gmarik/vundle" }
      end

      context "assume it's using vundle" do
        it { subject.parse("call vundle#rc()").should     == "gmarik/vundle" }
        it { subject.parse("    call vundle#rc()").should == "gmarik/vundle" }
      end

      context "assume it's using pathogen" do
        it { subject.parse("call pathogen#infect()").should        == "tpope/vim-pathogen" }
        it { subject.parse("    call pathogen#infect()").should    == "tpope/vim-pathogen" }
        it { subject.parse("    call    pathogen#infect()").should == "tpope/vim-pathogen" }
      end

      context "assume it's using neobundle" do
        it { subject.parse("       call neobundle#rc(expand('~/.vim/bundle/'))").should == "Shougo/neobundle.vim" }
        it { subject.parse("call neobundle#rc(expand('~/.vim/bundle/'))").should        == "Shougo/neobundle.vim" }
      end
    end
  end
end