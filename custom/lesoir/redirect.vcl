/**
 * 301 Permanent Redirect 
 */

sub redirect_301 {

      if ( req.url ~ "^/node$" ) { error 701 "/"; }

       if (req.http.Host == "www.lesnuitsdusoir.be" || req.http.Host == "www.lesoirenligne.be" || req.http.Host == "lesoirenligne.be" || req.http.Host == "www.chronologie.be" || req.http.Host == "www.swarado.be") {
        	error 701 "http://www.lesoir.be/";
       }
       elsif (req.http.Host == "www.petitegazette.be" || req.http.Host == "www.petite-gazette.be") {
        	error 701 "http://www.lesoir.be/14/actualit%C3%A9/petite-gazette";
       }
       elsif (req.http.Host == "victoiremag.lesoir.be" || req.http.Host == "www.victoiremag.be" || req.http.Host == "victoire.lesoir.be" || req.http.Host == "www.familles.be") {
                error 701 "http://www.lesoir.be/101826/styles/victoire";
       }
	   elsif ( req.url ~ "^/jsonexporter/product/1" ) { error 701 "http://www.lesoir.be/wallyflowpublish/product/1"; } 
	   elsif ( req.url ~ "^/jsonexporter/product/2" ) { error 701 "http://www.lesoir.be/wallyflowpublish/product/2"; } 
	   elsif ( req.url ~ "^/jsonexporter/product/3" ) { error 701 "http://www.lesoir.be/wallyflowpublish/product/3"; } 
	   elsif ( req.url ~ "^/jsonexporter/product/4" ) { error 701 "http://www.lesoir.be/wallyflowpublish/product/4"; } 
	   elsif ( req.url ~ "^/jsonexporter/product/5" ) { error 701 "http://www.lesoir.be/wallyflowpublish/product/5"; } 
       elsif ( req.url ~ "^/boutique" ) { error 701 "http://boutique.lesoir.be"; } 

       elsif ( req.url ~ "^/splash.html" ) { error 701 "http://www.lesoir.be/taxonomy/term/8"; }
       elsif ( req.url ~ "^/rubriques/la_une/page_" ) { error 701 "http://www.lesoir.be/taxonomy/term/8"; }
       elsif ( req.url ~ "^/actualite/le_fil_info" ) { error 701 "http://www.lesoir.be/taxonomy/term/8"; }
       elsif ( req.url ~ "^/sports/football/index.php" ) { error 701 "http://www.lesoir.be/taxonomy/term/8"; }
       elsif ( req.url ~ "^/opensso/UI/Login" ) { error 701 "http://www.lesoir.be/taxonomy/term/8"; }

/**
 *  Flux RSS
 */

       elsif ( req.url ~ "^/rss/la_une/page_5772.xml" )  { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/rss/belgique/page_5775.xml" )  { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Belgique/destination_principale_block/"; }

       elsif ( req.url ~ "^/actualite/communales_2012/rss_app.xml" )  { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Belgique/Communales/destination_principale_block?format=communales"; }
   
	   elsif ( req.url ~ "^/la_une/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/services/rss/la_une/index.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/actualite/belgique/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Belgique/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/economie/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Economie/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/economie/immo/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Economie/Immo/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/france/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/France/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/monde/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Monde/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/sciences/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Sciences%20et%20sant%C3%A9/default_destination_block/"; }
       elsif ( req.url ~ "^/actualite/vie_du_net/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Vie%20du%20net/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/"; }

       elsif ( req.url ~ "^/actualite/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/actualite/vie_du_net/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Vie%20du%20net/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/le_fil_info/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Fil%20Info/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/le_fil_info_sports/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/le_fil_info_economie/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Fil%20Info/Fil%20info%20Economie/destination_principale_block/"; }
       elsif ( req.url ~ "^/actualite/le_fil_info_elections_2010/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/actualite/le_fil_info_communales_2012/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/actualite/petite_gazette/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Petite%20gazette/"; }
       elsif ( req.url ~ "^/actualite/petite_gazette/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Petite%20gazette/"; }
       elsif ( req.url ~ "^/actualite/vu_sur_le_web/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/actualite/quizz/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/actualite/communales_2012/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/sports/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/football/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/football/standard/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/football/charleroi/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/football/anderlecht/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/football/modial/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/tennis/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/Tennis/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/sports_mecaniques/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/Sports%20m%C3%A9caniques/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/hockey/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/Hockey/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/basket/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/Basket/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/autres_sports/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/Autres%20sports/destination_principale_block/"; }
       elsif ( req.url ~ "^/sports/jo2012/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Sports/JO%202012/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Culture/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/cinema/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Culture/Cin%C3%A9ma/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/musiques/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Culture/Musiques/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/livres/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Culture/Livres/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/scenes/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Culture/Sc%C3%A8nes/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/arts_plastiques/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Culture/Arts%20plastiques/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/medias/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Culture/M%C3%A9dias%20-%20T%C3%A9l%C3%A9/destination_principale_block/"; }
       elsif ( req.url ~ "^/culture/airs_du_temps/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/Air%20du%20temps/destination_style_block/"; }
       elsif ( req.url ~ "^/regions/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/R%C3%A9gions/destination_principale_block/"; }
       elsif ( req.url ~ "^/regions/bruxelles/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/R%C3%A9gions/Bruxelles/destination_principale_block/"; }
       elsif ( req.url ~ "^/regions/brabant_wallon/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/R%C3%A9gions/Brabant%20Wallon/destination_principale_block/"; }
       elsif ( req.url ~ "^/regions/hainaut/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/R%C3%A9gions/Hainaut/destination_principale_block/"; }
       elsif ( req.url ~ "^/regions/liege/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/R%C3%A9gions/Li%C3%A8ge/destination_principale_block/"; }
       elsif ( req.url ~ "^/regions/namur_luxembourg/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/R%C3%A9gions/Namur%20-%20Luxembourg/destination_principale_block/"; }
       elsif ( req.url ~ "^/debats/editos/rss.xml" ) { error 701 "http://www.lesoir.be/feed/D%C3%A9bats/%C3%A9ditos/destination_debats_principal/"; }
       elsif ( req.url ~ "^/debats/a_bout_portant/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/debats/cartes_blanches/rss.xml" ) { error 701 "http://www.lesoir.be/feed/D%C3%A9bats/Cartes%20blanches/destination_debats_principal/"; }
       elsif ( req.url ~ "^/debats/chroniques/rss.xml" ) { error 701 "http://www.lesoir.be/feed/D%C3%A9bats/Chroniques/destination_debats_principal/"; }
       elsif ( req.url ~ "^/debats/chats/rss.xml" ) { error 701 "http://www.lesoir.be/feed/D%C3%A9bats/Chats/destination_debats_principal/"; }
       elsif ( req.url ~ "^/voyages/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/Voyages/destination_style_block/"; }
       elsif ( req.url ~ "^/lifestyle/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/destination_style_block/"; }
       elsif ( req.url ~ "^/lifestyle/air_du_temps/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/Air%20du%20temps/destination_style_block/"; }
       elsif ( req.url ~ "^/lifestyle/deco/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/Deco%20-%20Design/destination_style_block/"; }
       elsif ( req.url ~ "^/lifestyle/immo/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Economie/Immo/destination_principale_block/"; }
       elsif ( req.url ~ "^/lifestyle/auto/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/Auto/destination_style_block/"; }
       elsif ( req.url ~ "^/lifestyle/voyages/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/Voyages/destination_style_block/"; }
       elsif ( req.url ~ "^/lifestyle/cuisines/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Styles/Cuisines/destination_style_block/"; }
       elsif ( req.url ~ "^/lifestyle/news/rss.xml" ) { error 701 "http://www.lesoir.be/feed/La%20Une/destination_une_block/";  }
       elsif ( req.url ~ "^/lifestyle/sante/rss.xml" ) { error 701 "http://www.lesoir.be/feed/Actualit%C3%A9/Sciences%20et%20sant%C3%A9/default_destination_block/"; }
       elsif ( req.url ~ "^/feed/%C3%89dition%20abonn%C3%A9s/destination_principale_block?format=xmliphone" ) { error 701 "http://www.lesoir.be/feed/S%C3%A9lection%20abonn%C3%A9s/destination_principale_block?format=xmliphone"; }
       elsif ( req.url ~ "^/feed/%C3%89dition%20abonn%C3%A9s/destination_principale_block" ) { error 701 "http://www.lesoir.be/feed/S%C3%A9lection%20abonn%C3%A9s/destination_principale_block"; }
       elsif ( req.url ~ "^/feed/Actualit%C3%A9/Vie%20du%20net/destination_principale_block?format=xmliphone" ) { error 701 "http://www.lesoir.be/feed/Economie/Vie%20du%20net/destination_principale_block?format=xmliphone"; }

/**
 *  Anciennes URLs rubriques
 */
       elsif ( req.url ~ "^/actualite/belgique/elections_2010/(index\.php)?" ) { error 701 "http://www.lesoir.be/"; }
       elsif ( req.url ~ "^/actualite/belgique/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/8"; }
       elsif ( req.url ~ "^/actualite/economie/agriculture/" ) { error 701 "http://www.lesoir.be/taxonomy/term/83"; }
       elsif ( req.url ~ "^/actualite/economie/bourses/" ) { error 701 "http://www.lesoir.be/taxonomy/term/83"; }
       elsif ( req.url ~ "^/actualite/economie/forexpros/" ) { error 701 "http://www.lesoir.be/taxonomy/term/83"; }
       elsif ( req.url ~ "^/actualite/economie/immo/" ) { error 701 "http://www.lesoir.be/taxonomy/term/83"; }
       elsif ( req.url ~ "^/actualite/economie/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/83"; }
       elsif ( req.url ~ "^/actualite/france/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/9"; }
       elsif ( req.url ~ "^/actualite/monde/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/10"; }
       elsif ( req.url ~ "^/actualite/petite_gazette/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/14"; }
       elsif ( req.url ~ "^/actualite/quiz/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/16"; }
       elsif ( req.url ~ "^/actualite/sciences/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/13"; }
       elsif ( req.url ~ "^/actualite/vie_du_net/(index\.php)?" ) { error 701 "http://www.lesoir.be/taxonomy/term/12"; }
       elsif ( req.url ~ "^/ftp/Barometer/trafficlength\.xml?" ) { error 701 "http://www.lesoir.be/sites/default/files/import/trafic/Barometer/trafficlength.xml"; }
       elsif ( req.url ~ "^/la_une/" ) { error 701 "http://www.lesoir.be/"; }

/**
 *  URLs externes
 */    
	
       elsif ( req.url ~ "^/langues" ) { error 701 "http://langues.lesoir.be"; }
       elsif ( req.url ~ "^/footlive" ) { error 701 "http://http://football.lesoir.be"; }
       elsif ( req.url ~ "^/moijeux" ) { error 701 "http://blogs.lesoir.be/moi_jeux"; }
       elsif ( req.url ~ "^/facenord" ) { error 701 "http://blogs.lesoir.be/facenord/"; }
       elsif ( req.url ~ "^/lesgrandsproces" ) { error 701 "http://blogs.lesoir.be/grandsproces/"; }   
       elsif ( req.url ~ "^/madness" ) { error 701 "http://blogs.lesoir.be/madness/"; }
       elsif ( req.url ~ "^/msf" ) { error 701 "http://blogs.lesoir.be/leblogdesmsf/"; }
	   elsif ( req.url ~ "^/colettebraeckman" ) { error 701 "http://blogs.lesoir.be/colette-braeckman/"; }
	   elsif ( req.url ~ "^/tousenscenes" ) { error 701 "http://blogs.lesoir.be/tousenscenes/"; }
	   elsif ( req.url ~ "^/jourapresjour" ) { error 701 "http://blogs.lesoir.be/chronologie/"; }
       elsif ( req.url ~ "^/ketpaddle" ) { error 701 "http://blogs.lesoir.be/ketpaddle/"; }
	   elsif ( req.url ~ "^/biodegradable" ) { error 701 "http://blogs.lesoir.be/empreinte-eco/"; }
	   elsif ( req.url ~ "^/frontstage" ) { error 701 "http://blogs.lesoir.be/festivals/"; }
	   elsif ( req.url ~ "^/festivals" ) { error 701 "http://blogs.lesoir.be/festivals/"; }
	   elsif ( req.url ~ "^/entractes" ) { error 701 "http://blogs.lesoir.be/entractes"; }
	   elsif ( req.url ~ "^/portfolios" ) { error 701 "http://portfolio.lesoir.be/main.php"; }
	   elsif ( req.url ~ "^/foot" ) { error 701 "http://football.lesoir.be"; }
	   elsif ( req.url ~ "^/facebook" && req.url !~ "^/facebook_callback" ) { error 701 "http://www.facebook.com/pages/Lesoirbe/150606180090"; }
	   elsif ( req.url ~ "^/ventesprivees" ) { error 701 "http://lesoir.viprive.com/"; }
	   elsif ( req.url ~ "^/tickets" ) { error 701 "http://tickets.lesoir.be"; }
	   elsif ( req.url ~ "^/clim8" ) { error 701 "http://blogs.lesoir.be/empreinte-eco/category/copenhague-2009/le-carnet-de-bord-de-clim8/"; }
	   elsif ( req.url ~ "^/cop09" ) { error 701 "http://blogs.lesoir.be/empreinte-eco/"; }
	   elsif ( req.url ~ "^/copenhague" ) { error 701 "http://blogs.lesoir.be/empreinte-eco/le-sommet-de-copenhague/"; }
	   elsif ( req.url ~ "^/cop15" ) { error 701 "http://blogs.lesoir.be/empreinte-eco/"; }
	   elsif ( req.url ~ "^/iphone" ) { error 701 "http://iphoneapp.lesoir.be/"; }
	   elsif ( req.url ~ "^/googlebuzz" ) { error 701 "http://www.google.com/profiles/lesoirbe"; }
	   elsif ( req.url ~ "^/footwal" ) { error 701 "http://pdf.lesoir.be/special/footwal"; }
	   elsif ( req.url ~ "^/hal" ) { error 701 "http://pdf.lesoir.be/special/hal"; }
	   elsif ( req.url ~ "^/formule1" ) { error 701 "http://formule1.lesoir.be/"; }
	   elsif ( req.url ~ "^/filmsalaffiche" ) { error 701 "http://portfolio.lesoir.be/v/culture/cinema/_films/"; }
	   elsif ( req.url ~ "^/congo" ) { error 701 "http://pdf.lesoir.be/special/congo"; }
	   elsif ( req.url ~ "^/amortieetlob" ) { error 701 "http://blogs.lesoir.be/amortieetlob/"; }
	   elsif ( req.url ~ "^/blogtennis" ) { error 701 "http://blogs.lesoir.be/amortieetlob/"; }
	   elsif ( req.url ~ "^/puggy" ) { error 701 "http://blogs.lesoir.be/festivals/category/journal-de-puggy/"; }
	   elsif ( req.url ~ "^/ipad" ) { error 701 "http://itunes.apple.com/be/app/le-soir/id366432648?mt=8"; }
	   elsif ( req.url ~ "^/android" ) { error 701 "http://iphoneapp.lesoir.be/"; }
	   elsif ( req.url ~ "^/salledesprofs" ) { error 701 "http://blogs.lesoir.be/salledesprofs/"; }
	   elsif ( req.url ~ "^/mad" ) { error 701 "http://mad.lesoir.be"; }
	   elsif ( req.url ~ "^/neilyoung" ) { error 701 "http://blogs.lesoir.be/festivals/"; }
	   elsif ( req.url ~ "^/musulmans" ) { error 701 "https://spreadsheets.google.com/ccc?key=0Am3vHevPFEW9dFBUNTlxMWgtN2NCRXAyOXUyenBzWGc&hl=en&authkey=CKObvJAD#/"; }
	   elsif ( req.url ~ "^/geeko" ) { error 701 "http://geeko.lesoir.be "; }
	   elsif ( req.url ~ "^/blackberry" ) { error 701 "http://appworld.blackberry.com/webstore/content/36911?lang=fr"; }
	   elsif ( req.url ~ "^/Gagarine" ) { error 701 "http://portfolio.lesoir.be/v/sciences/2011_04_07_gaga/"; }
	   elsif ( req.url ~ "^/ipad2" ) { error 701 "http://concours.lesoir.be/refresh/2907_3/concours-ipad2-a-gagner-chaque-jour.html"; }
	   elsif ( req.url ~ "^/zazie" ) { error 701 "http://blog.lesoir.be/frontstage/2011/05/16/a-la-rencontre-de-zazie-a-la-fnac/"; }
	   elsif ( req.url ~ "^/freefight" ) { error 701 "http://blog.lesoir.be/freefight-webdoc/"; }
	   elsif ( req.url ~ "^/mail" ) { error 701 "http://pdf.lesoir.be/authentification/forget.php?aff=FULL"; }
	   elsif ( req.url ~ "^/pseudo" ) { error 701 "http://pdf.lesoir.be/mon_profil/data/reconciliation.php?app=cds"; }
	   elsif ( req.url ~ "^/rock" ) { error 701 "http://blog.lesoir.be/frontstage/concours-rock-werchter-7-x2-places-a-remporter/"; }
	   elsif ( req.url ~ "^/elec1306" ) { error 701 "http://pdf.lesoir.be/special/elec1306/"; }
	   elsif ( req.url ~ "^/APBSoir" ) { error 701 "http://www.lesoir.be/services/minisites/abonSoir3972S/Action.php"; }
  	   elsif ( req.url ~ "^/APBSoirmagazine" ) { error 701 "http://www.lesoir.be/services/minisites/abon3972SM/Action.php"; }
	   elsif ( req.url ~ "^/drone" ) { error 701 "http://belgium-iphone.lesoir.be/2011/06/28/drone/"; }
	   elsif ( req.url ~ "^/doors" ) { error 701 "http://blog.lesoir.be/frontstage/5-box-des-doors-a-gagner/"; }
	   elsif ( req.url ~ "^/ING" ) { error 701 "https://surveys.automatesurvey.com/11.029.3/s?p=W18580401S12&h=284136"; }
	   elsif ( req.url ~ "^/chocolat" ) { error 701 "http://concours.lesoir.be/quiz/4273_3/gagnez-un-an-de-chocolat-newtree.html"; }
	   elsif ( req.url ~ "^/belgotron" ) { error 701 "http://belgium-iphone.lesoir.be/2011/12/12/belgotron-concours/"; }
	   elsif ( req.url ~ "^/nespresso" ) { error 701 "http://concours.lesoir.be/quiz/5747_3/concours-nespresso-un-an-de-cafe.html"; }
	   elsif ( req.url ~ "^/nokia" ) { error 701 "http://geeko.lesoir.be/2011/12/18/concours-nokia-700-geeko/"; }
	   elsif ( req.url ~ "^/ipad8" ) { error 701 "http://www.lesoir.be/services/abonnement/index.php?support=ipad&code=Abribus1&app="; }
	   elsif ( req.url ~ "^/jesuisleboss" ) { error 701 "http://studioweb.lesoir.be/FormManager/content/jesuisleboss"; }
	   elsif ( req.url ~ "^/addition" ) { error 701 "http://studioweb.lesoir.be/FormManager/content/jesuisleboss"; }
	   elsif ( req.url ~ "^/tabous" ) { error 701 "http://blog.lesoir.be/tabous/"; }
	   elsif ( req.url ~ "^/parcasterix" ) { error 701 "http://concours.lesoir.be/quiz/9290_3/parc-asterix.html"; }
	   elsif ( req.url ~ "^/ladouce" ) { error 701 "http://blog.lesoir.be/ketpaddle/2012/04/16/francois-schuiten-en-realite-augmentee"; }
	   elsif ( req.url ~ "^/belgeolympique" ) { error 701 "http://concours.lesoir.be/quiz/12564_3/concours-exclusif.html"; }
	   elsif ( req.url ~ "^/zencar" ) { error 701 "http://concours.lesoir.be/quiz/10743_3/avec-zen-car-et-le-soir-gagnez-50-abonnements-de-3-mois-pour-silloner-bruxelles-en-voiture-electrique.html"; }
	   elsif ( req.url ~ "^/topbxl" ) { error 701 "http://studioweb.lesoir.be/mini06/"; }
	   elsif ( req.url ~ "^/dino" ) { error 701 "http://studioweb.lesoir.be/dino/"; }
	   elsif ( req.url ~ "^/dinos" ) { error 701 "http://studioweb.lesoir.be/dino/"; }
	   elsif ( req.url ~ "^/dinosaures" ) { error 701 "http://studioweb.lesoir.be/dino/"; }
	   elsif ( req.url ~ "^/dinosaure" ) { error 701 "http://studioweb.lesoir.be/dino/"; }
	   elsif ( req.url ~ "^/johnniewalker" ) { error 701 "http://concours.lesoir.be/quiz/13345_3/concours-whisky.html"; }
	   elsif ( req.url ~ "^/xbox" ) { error 701 "http://concours.lesoir.be/quiz/13572_3/xbox-360.html"; }
	   elsif ( req.url ~ "^/WP" ) { error 701 "http://windowsphone.com/s?appid=09e40463-f624-4c47-8e14-5908425c8a5c"; }
	   elsif ( req.url ~ "^/wp" ) { error 701 "http://windowsphone.com/s?appid=09e40463-f624-4c47-8e14-5908425c8a5c"; }
	   elsif ( req.url ~ "^/lumia" ) { error 701 "http://concours.lesoir.be/quiz/14622_3/nokia-lumia-900.html"; }
}

/**
 * 302 Redirect 
 */
sub redirect_302 {
    if (req.http.Host == "www.lesoirimmo.be" || req.http.Host == "lesoirimmo.be" || req.http.Host == "www.lesoirimmo.com" || req.http.Host == "lesoirimmo.com" || req.http.Host == "www.soirimmo.be" || req.http.Host == "soirimmo.be" || req.http.Host == "www.soirimmo.com" || req.http.Host == "soirimmo.com" || req.http.Host == "decoimmo.be" || req.http.Host == "www.decoimmo.be" || req.http.Host == "decoimmo.com" || req.http.Host == "www.decoimmo.com") {
        error 702 "http://www.lesoir.be/actu/economie/immo-99";
    }
}

/**
 * On gere les codes 701 / 702 pour les redirects. 
 */
sub redirect_error {
	#
    if (obj.status == 701) {
        set obj.http.Location = obj.response;
        set obj.status = 301;
        return(deliver);
    }

	# 
    if (obj.status == 702) {
        set obj.http.Location = obj.response;
        set obj.status = 302;
        return(deliver);
    }


}
