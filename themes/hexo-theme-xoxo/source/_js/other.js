(function () {
  window.FantaReport.initReport({
    reportHost: 'https://api.lion1ou.tech/track',
    debug: false,
    appName: 'lion1ou',
  });

  const sT = setTimeout(() => {
    window.FantaReport.pageView();
    clearTimeout(sT);
  }, 1000);
})();
