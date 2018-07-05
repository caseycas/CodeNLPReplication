import json
import sys
import os



try:
    recipe_file = sys.argv[1]
    output_dir = sys.argv[2]
except:
    print("python recipeCorpusBuilder.py recipe_file output_dir")
    quit()



recipes = json.load(open(recipe_file, 'r'))
i = 0
for r in recipes:
    with open(os.path.join(output_dir, str(i) + ".tokens"), 'w') as f:
        #print(os.path.join(output_dir, str(i) + ".tokens"))
        inst_list = r['instructions']
        for line in inst_list:
            #print(line['text'])
            f.write(line['text'] + "\n")

    i += 1
