<!DOCTYPE html>
<html lang="ja">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="shortcut icon" href="favicon.ico">

    <title>九工大アプリ P&D</title>

    <!-- Bootstrap Core CSS -->
    <%= stylesheet_link_tag("info/bootstrap.min.css") %>
    <!-- Custom CSS -->
    <%= stylesheet_link_tag("info/landing-page.css") %>
    <%= stylesheet_link_tag("info/vegas.css") %>
    <%= stylesheet_link_tag("info/vegas.css") %>


    <!-- Custom Fonts -->

    <link href="https://fonts.googleapis.com/css?family=Lato:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css">

</head>

<body>

    <!-- Navigation -->
    <nav class="navbar navbar-default navbar-fixed-top topnav" role="navigation">
        <div class="container topnav">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                    <span class="sr-only"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand topnav" href="#">九工大アプリ</a>
            </div>
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
                <ul class="nav navbar-nav navbar-right">
                    <li>
                        <a href="#intro-back">ホーム</a>
                    </li>
                    <li>
                        <a href="#services">コンテンツ</a>
                    </li>
                    <li>
                        <a href="#contact">コンタクト</a>
                    </li>
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

    <!-- Header -->
    <a name="about"></a>
    <div id="intro-back" class="intro-header">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <div class="intro-message">
                        <h3>九工大生必須アイテム！</h3>
                        <h1>「九工大アプリ」</h1>
                        <h4>電子掲示板情報とバスの時刻表はもちろん、時間割機能が追加してパワーアップしました</h4>
                        <h4>「九工大アプリ」を落とさなくて何を落としているんだ！！</h4>
                        <hr class="intro-divider">
                        <ul class="list-inline intro-social-buttons">
                            <li>
                                <a href="https://itunes.apple.com/jp/app/jiu-gong-da/id658354583?mt=8" class="btn">
                                        <img src="<%= image_path('info/dl_ios.png') %> "> 
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.intro-header -->

    <!-- Page Content -->

    <a name="services"></a>
    <div class="content-section-a">

        <div class="container">
            <div class="row">
                <div class="col-lg-5 col-sm-6">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading">時間割</h2>
                    <h4 class="section-heading">九工大生のあったら便利を考えました</h4>
                    <p class="lead">九工大のシラバスと連携しているので探す手間も、手動で打ち込む手間もありません。
                        <br>
                        <br>時間割の作成・編集が楽チンの必須機能です。
                    </p>
                </div>
                <div class="col-lg-5 col-lg-offset-2 col-sm-6">
                    <img class="img-responsive" src=<%= image_path("info/time.png") %> alt="">
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.content-section-a -->

    <div class="content-section-b">
        <div class="container">

            <div class="row">
                <div class="col-lg-5 col-lg-offset-1 col-sm-push-6  col-sm-6">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading">バス時刻表</h2>
                    <h4 class="section-heading">あれ、何時だっけ？を最短で解決します</h4>
                    <p class="lead">「九工大発」「バスセンター発」「新飯塚駅発」ごとに通常便と減便の時刻表が確認できます。
                        <br>
                        <br>運行日程が確認できるカレンダー機能も追加！
                    </p>
                </div>
                <div class="col-lg-5 col-sm-pull-6  col-sm-6">
                    <img class="img-responsive" src=<%= image_path("info/bus.png") %> alt="">
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.content-section-b -->

    <div class="content-section-a">

        <div class="container">

            <div class="row">
                <div class="col-lg-5 col-sm-6">
                    <hr class="section-heading-spacer">
                    <div class="clearfix"></div>
                    <h2 class="section-heading">掲示板</h2>
                    <h4 class="section-heading">ココを確認すれば見逃しはありません</h4>
                    <p class="lead">九工大の電子掲示板の情報が手元で確認できます。
                        <br>
                        <br>カテゴリーで検索できる新機能も搭載して、さらに使いやすくなりました。</p>
                </div>
                <div class="col-lg-5 col-lg-offset-2 col-sm-6">
                    <img class="img-responsive" src=<%= image_path("info/board.png") %> alt="">
                </div>
            </div>

        </div>
        <!-- /.container -->
    </div>
    <!-- /.content-section-a -->

    <a name="contact"></a>
    <div class="banner">
        <div class="container">
            <div class="row">
                <div class="col-lg-6">
                    <h2>P&Dに連絡</h2>
                </div>
                <div class="col-lg-6">
                   <div class="pull-left">
                   <ul class="list-inline banner-social-buttons">
                            <li>
                                <a href="https://docs.google.com/forms/d/1Q0GZ2K_k0TCi65wWjgTzq1vPSFyNrJr5SUDqwUH37no/viewform?usp=send_form" class="btn btn-default btn-lg"><i class="fa fa-comments fa-fw"></i> <span class="network-name">連絡する</span></a>
                            </li>
                    </div>
                    <div class="pull-right">
                        <ul class="list-inline banner-social-buttons">
                            <li>
                                <a href="https://itunes.apple.com/jp/app/jiu-gong-da/id658354583?mt=8" class="btn">
                                         <img src="<%= image_path('info/dl_ios.png') %> "> 
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.banner -->

    <div class="content-section-b">

        <div class="container">

            <div class="row">

                <div class="col-lg-6 col-md-6  .col-sm-10 .col-sm-offset-1 .col-xs-10 .col-xs-offset-1">
                    <a class="twitter-timeline" href="https://twitter.com/kyutech_info" data-widget-id="645510476323942400" lang="ja">@kyutech_infoさんのツイート</a>
                </div>
                <div class="col-lg-6 col-md-6 .col-sm-10 .col-sm-offset-1 .col-xs-10 .col-xs-offset-1">
                    <a class="twitter-timeline" href="https://twitter.com/planningdev" data-widget-id="645522529138831364">@planningdevさんのツイート</a>
                </div>
            </div>

        </div>
        <!-- /.container -->

    </div>
    <!-- /.content-section-b -->

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <ul class="list-inline">
                        <li>
                            <a href="#about">Home</a>
                        </li>
                        <li class="footer-menu-divider">&sdot;</li>
                        <li>
                            <a href="#services">Services</a>
                        </li>
                        <li class="footer-menu-divider">&sdot;</li>
                        <li>
                            <a href="#contact">Contact</a>
                        </li>
                    </ul>
                    <p class="copyright text-muted small">Copyright &copy; P&D 2015. All Rights Reserved</p>
                </div>
            </div>
        </div>
    </footer>

    <!-- jQuery -->
    <%= javascript_include_tag("info/jquery.js")%>

    <!-- Bootstrap Core JavaScript -->
    <%= javascript_include_tag("info/bootstrap.min.js")%>

    <!--  Custom JavaScript-->

    <%= javascript_include_tag("info/vegas.js")%>
    <%= javascript_include_tag("info/background.js")%>
    <!-- Twitter JS -->
    <script>
        ! function (d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0],
                p = /^http:/.test(d.location) ? 'http' : 'https';
            if (!d.getElementById(id)) {
                js = d.createElement(s);
                js.id = id;
                js.src = p + "://platform.twitter.com/widgets.js";
                fjs.parentNode.insertBefore(js, fjs);
            }
        }(document, "script", "twitter-wjs");
    </script>

</body>

</html>