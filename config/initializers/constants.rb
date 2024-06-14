module Constants 
  JAPAN_METEOROLOGICAL_AGENCY = 'https://www.data.jma.go.jp'
  JMA_SITE_TOP_STATION = '/gmd/risk/obsdl/top/station'
  JMA_SITE_AME_MASTER = '/stats/data/mdrr/chiten/meta/amdmaster.index4'
  JMA_SITE_REGION_STATION = '/gmd/risk/obsdl/top/station'
  JMA_SITE_DOWNLOAD_TOP = '/risk/obsdl/index.php'
  JMA_SITE_DOWNLOAD_MESUREMENT = '/risk/obsdl/show/table'
  HTML_DUMMY_HEADER = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' +
      '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ja" lang="ja" style="" class=" js flexbox canvas canvastext webgl no-touch geolocation postmessage no-websqldatabase indexeddb hashchange history draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow textshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms csstransforms3d csstransitions fontface generatedcontent video audio localstorage sessionstorage webworkers no-applicationcache svg inlinesvg smil svgclippaths">' +
      '<head>' +
      '<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">' +
      '</head>' +
      '<body>'
  HTML_DUMMY_FOOTER = '</body>' +
      '</html>'
end

Constants.freeze
