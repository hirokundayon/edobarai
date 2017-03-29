# Selenium WebDriverを動かすPowerShellスクリプトの動かし方
<div style="text-align: right;">
東平洋史
</div>

1. はじめに  
   この資料は Selenium WebDriver を動かすPowerShellスクリプト edobarai.ps1 の動かし方を記述したものです。このPowerShellスクリプトは次の手順で、太宰府で開かれたOSC2011 Fukuokaのレポートを表示させます。  
   1. Webブラウザを起動します。  
   2. Googleのページを表示します。  
   3. 「OSC Fukuoka 太宰府」をキーに検索します。  
   4. 「OSC2011 Fukuoka 太宰府にて開催！！」の記事へのリンクをクリックします。  
   5. 表示されたLTの写真をクリックします。  
   6. 表示されたLTの写真をクリックします。  
   7. 10秒待ちます。  
   8. 起動したWebブラウザを終了させます。  
2. 準備  
    1. Selenium Standalone Serverのダウンロード  
    次のURLからSelenium Standalone Serverを取得します。  
    <http://www.seleniumhq.org/download/>  
3. Selenium Standalone Serverの起動  
    selenium-standalone-server.bat を叩いてSelenium Standalone Serverを起動します。  
    なお、各ファイルへのパス(/path/to)は予め適切なものに変更してください。  
4. シェルスクリプトの起動  
   以上で準備完了です。PowerShellスクリプトを起動しましょう。  
   1. Google Chromeを起動する場合  
   `> .\edobarai.ps1`  
   または  
   `> .\edobarai.ps1 chrome`  
   2. Internet Explorerを起動する場合  
   `> .\edobarai.ps1 ie`  
   3. Mozilla Firefoxを起動する場合  
   `> .\edobarai.ps1 firefox`  
   4. Microsoft Edgeを起動する場合  
   `> .\edobarai.ps1 edge`  
5. 参考文献  
   1. WebDriver  
      Living Document  
      W3C Editor's Draft 28 April 2016  
      <https://w3c.github.io/webdriver/webdriver-spec.html>  
   2. Invoke-RestMethod  
      <https://msdn.microsoft.com/powershell/reference/5.1/microsoft.powershell.utility/Invoke-RestMethod>  
   3. Seleniumの薄っすい話4:俺と非公式バインディング  
      <http://qiita.com/hiroshitoda/items/5fa5292ceb1e3e8a9610>  
   4. OSC2011 Fukuoka 太宰府にて開催！！  
      <https://www.ospn.jp/press/20111219osc2011-fukuoka-report.html>  
   5. SI-Toolkit for Web Testing ハンズオン勉強会  
      <https://www.slideshare.net/yuichi_kuwahara/sitoolkit-for-web-testing>  
