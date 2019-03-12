from getgauge.python import step
from selenium.webdriver import Firefox
from selenium.webdriver.firefox.options import Options

opts = Options()
opts.set_headless()
browser = Firefox(options=opts)

@step('<a> equals <b>')
def equals(a, b):
  a == b

@step('goto <url>')
def goto(url):
  browser.get(url)