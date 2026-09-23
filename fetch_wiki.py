import urllib.request
import json
import urllib.parse

queries = [
    "Smartphone", "Earbuds", "Flat screen television", "Laptop", "Smartwatch",
    "Dress shirt", "Running shoes", "Backpack", "Aviator sunglasses", "Leather wallet",
    "Coffee maker", "Frying pan", "Desk lamp", "Blender", "Bed sheet",
    "Java programming book", "Hardcover book", "Computer programming book", "Software engineering book", "Notebook",
    "Dumbbell", "Yoga mat", "Protein powder", "Jump rope", "Water bottle"
]

images = []

for q in queries:
    url = f"https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages&generator=search&gsrsearch={urllib.parse.quote(q)}&gsrlimit=1&pithumbsize=600"
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode('utf-8'))
            pages = data.get('query', {}).get('pages', {})
            img_url = ""
            for page_id, page_info in pages.items():
                if 'thumbnail' in page_info:
                    img_url = page_info['thumbnail']['source']
                    break
            if img_url:
                images.append(img_url)
            else:
                images.append("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png")
    except Exception as e:
        images.append("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png")

output = "    private static final String[] CATALOG_IMAGES = {\n"
for url in images:
    output += f'        "{url}",\n'
output += "    };\n"

with open("wiki_images.txt", "w", encoding='utf-8') as f:
    f.write(output)
