const SECONDS = 1000;
const MINUTES = SECONDS * 60;
const HOURS = MINUTES * 60;
const DAYS = HOURS * 24;
const YEARS = DAYS * 365;

hexo.extend.helper.register('siteTime', function (siteStartTime) {
  var start = new Date(siteStartTime).getTime();
  var today = new Date().getTime();
  var diff = today - start;
  // var diffYears = Math.floor(diff / YEARS);
  var diffDays = Math.floor(diff / DAYS);
  // var diffDays = Math.floor(diff / DAYS - diffYears * 365);
  // var diffHours = Math.floor((diff - (diffYears * 365 + diffDays) * DAYS) / HOURS);
  // var diffMinutes = Math.floor((diff - (diffYears * 365 + diffDays) * DAYS - diffHours * HOURS) / MINUTES);
  // var diffSeconds = Math.floor((diff - (diffYears * 365 + diffDays) * DAYS - diffHours * HOURS - diffMinutes * MINUTES) / SECONDS);
  return `${diffDays ? `${diffDays} 天 ` : ''}`;
  // return  `${diffYears ? `${diffYears} 年 ` : ''}${diffYears || diffDays ? `${diffDays} 天 ` : ''}${diffYears || diffDays || diffHours ? `${diffHours} 小时 ` : ''}${diffYears || diffDays || diffHours || diffMinutes ? `${diffMinutes} 分钟 ` : ''}${diffYears || diffDays || diffHours || diffMinutes || diffSeconds ? `${diffSeconds} 秒` : ''}`;
});


hexo.extend.helper.register('currentHref', function () {
  return window.location.href
});