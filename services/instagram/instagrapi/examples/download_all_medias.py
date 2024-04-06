import os
import sys

from instagrapi import Client

def get_env_var(var_name):
    var_value = os.getenv(var_name)
    if var_value is None:
        raise Exception(f'Environment variable {var_name} is not set.')
    return var_value

def download_media(cl, media):
    paths = []
    if media.media_type == 1:
        # Photo
        paths.append(cl.photo_download(media.pk))
    elif media.media_type in (2, 5):
        # Video or Carousel Video
        paths.append(cl.video_download(media.pk))
    elif media.media_type == 8:
        # Album
        for path in cl.album_download(media.pk):
            paths.append(path)
    return paths

def main(username: str, amount: int = 5) -> dict:
    """
    Download all medias from instagram profile
    """
    amount = int(amount)
    cl = Client()
    try:
        cl.login(get_env_var('IG_USERNAME'), get_env_var('IG_PASSWORD'))
    except Exception as e:
        print(f'Error logging in: {e}')
        sys.exit(1)
    user_id = cl.user_id_from_username(username)
    medias = cl.user_medias(user_id)
    result = {}
    i = 0
    for media in medias:
        if i >= amount:
            break
        paths = download_media(cl, media)
        result[media.pk] = paths
        print(f"http://instagram.com/p/{media.code}/", paths)
        i += 1
    return result

if __name__ == "__main__":
    username = input("Enter username: ")
    while True:
        amount = input("How many posts to process (default: 5)? ").strip()
        if amount == "":
            amount = "5"
        if amount.isdigit():
            break
    main(username, amount)
