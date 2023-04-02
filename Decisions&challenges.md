# Decisions & Challenges


Type ambiguity:
- Along with search results, I also wanted to persist favorites via Core Data. This lead to declaring a common protocol to handle both search results and favorites. However, this in turn caused the addition/removal of favorites to affect the search results entities as well. Fixed by making copies of type 'any MovieProtocol'.

Short-term persistence for favorites:
- Removing favorites via the detail screen would logically remove the movie data immediately, and consequently clear the detail screen. But it would be more user-friendly to allow the detail screen to persist, for instance if the user changes their mind and re-favorites. Fixed by making copies of type 'any MovieProtocol'.   

Updating CoreData entities in memory:
- Core Data entities persist in memory despite 'execute(deleteRequest)'. Fixed by manually updating in-memory object following 'execute(deleteRequest)' as well as 'moc.automaticallyMergesChangesFromParent = true'.

View reactivity in NavigationStack:
- The favorites heart icon appearance did not automatically update with changes to favorites. Fixed by manually reloading via '.id()'. 

URL encoding:
- Including spaces in the middle of query strings leads to zero api reponse results with no erros. This is due to how the api encodes spaces as '+' rather than '%20'. Fixed by replacing mid-query spaces with '+'. 

UI Design:
- Minimalist design and pale colour palette inorder to reduce the visual clutter of multiple movie poster images.
- Considering that the requirements for the search screen are to display (only) title, release date and poster image, most of the information the user wll be receiving from each movie would come from the poster image, hence I decided to have relatively large poster images.
- Large poster images reduces the maximum results that can be seen at a time and increases the amount of scrolling needed. And so I added a button to that can automatically scroll to the top.

Verbosity vs cohesiveness:
 - Eg. Although the grid of movies that are search results and the grid of movies that are favorites are very similar and can be enveloped into a single file, I decided to keep them seperate inorder to increase readability and be more verbose at the cost of cohesiveness given the (current) small scale of the app.





