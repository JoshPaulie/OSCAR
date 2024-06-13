import re
from typing import TypeVar

import requests
import rumps
from bs4 import BeautifulSoup

T = TypeVar("T")


def val(_: str, value: T) -> T:
    """
    Create a single-use, labled number, without clogging the namespace

    Q: Why not just use `("name", value)[1]`?
    A: Because then you wouldn't get this docstring, silly :)
    """
    return value


def rs_number(number: int) -> str:
    if number >= 1_000_000:
        return f"{number / 1_000_000:.1f}M"
    elif number >= 1_000:
        return f"{number / 1_000:.1f}K"
    return str(number)


def get_homepage() -> str:
    OSRS_HOMEPAGE_URL = "https://oldschool.runescape.com/"
    result = requests.get(OSRS_HOMEPAGE_URL).text
    return result


def get_player_count_tag_text():
    homepage = get_homepage()
    soup = BeautifulSoup(homepage, features="html.parser")
    paragraph_tags = soup.findAll("p")
    for paragraph in paragraph_tags:
        if classes := paragraph.get("class"):
            if classes[0] == "player-count":
                return paragraph.text
    raise ValueError("Unable to find player-count paragraph tag")


def get_player_count() -> int:
    player_count_text = get_player_count_tag_text()
    if player_count := re.search(r"\d{1,3}(?:,\d{3})*", player_count_text):
        return int(player_count.group().replace(",", ""))
    raise ValueError(f"Unable to parse player count from player-count paragraph tag: '{player_count_text}'")


class StatusBarApp(rumps.App):
    """OSCAR - Old School Current Active RuneScapers

    Simple status bar app that reflects the current player count"""

    def __init__(self):
        print("Starting OSCAR ..")
        super(StatusBarApp, self).__init__("OSCAR")
        self.menu = ["Refresh"]

    @rumps.timer(val("10 mintues", 600))
    def auto_update_title(self, sender):
        self.update_title(sender)

    @rumps.clicked("Refresh")
    def refresh(self, sender):
        self.update_title(sender)

    def update_title(self, sender):
        try:
            player_count = get_player_count()
        except requests.exceptions.ConnectionError:
            self.title = "No internet!"
            print("Status couldn't be updated, no internet connection")
        except ValueError as e:
            print("Uh oh. It seems Jagex changed the OSRS homepage.")
            print("Fatal Error:", e)
            print("Closing app. Please file an issue on GitHub")
            rumps.quit_application()
        else:
            player_count_str = rs_number(player_count)
            self.title = player_count_str
            print("Updated player count:", player_count_str)


if __name__ == "__main__":
    StatusBarApp().run()
