var mobileNav = document.querySelector('.mobile-nav');
var mobileHamburger = document.querySelector('.mobile-hamburger');
mobileHamburger.onclick = function() {
  if (mobileNav.className.indexOf('hide') >= 0) {
    mobileNav.className = mobileNav.className.replace('hide', 'show');
  } else {
    mobileNav.className = mobileNav.className.replace('show', 'hide');
  }
};
