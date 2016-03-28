class ReleaseNoteController < ApplicationController
  def index
    @titles = ["【ios】九工大アプリ(4.1.0)をリリース！",
	"九工大botが３キャンパスに対応しました"]
    @texts = [
      ["新機能","・３キャンパスに対応","・時間割がクォーター制に対応","・時間割の詳細が閲覧可能に","・九工大に関する時刻表を検索できるようになりました","・moodleやLiveCampusへのリンクを追加",
	"動作環境","・iOS 9以上対応"],
      ["新機能",
	"・飯塚キャンパス（電子掲示板、飯塚HP）",
	"・戸畑キャンパス（戸畑HP）",
	"・若松キャンパス（若松HP）"
	],
    ]
  end
end
