# TODO

### Collections from wishlist
* [FeedCollectionViewController](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/View%20Controllers/Feed/FeedCollectionViewController/FeedCollectionViewController.swift) - изменить DataSource на [Collection.all](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Models/Collections/Collection%2Ball.swift) для Collections из Wishlist

* [FeedCollectionViewController](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/View%20Controllers/Feed/FeedCollectionViewController/FeedCollectionViewController.swift) - проверить сортировку коллекций после изменения DataSource

* [Collection.all](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/Models/Collections/Collection%2Ball.swift) после перехода DataSource в FeedCollectionViewController на Collection.all переделать методы append, update, remove используя ID коллекции и проверить их вызовы

* [ItemViewController+Actions](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/View%20Controllers/Main/ItemViewController/ItemViewController%2BActions.swift) - рефакторинг внутри методов orderButtonTapped() и deleteButtonTapped() 

### Feed
* [FeedCollectionViewController+Picks](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/View%20Controllers/Feed/FeedCollectionViewController/FeedCollectionViewController+Picks.swift) - вероятно стоит заблокировать возможность нажатия кнопки See All до того момента пока все items не будут загружены, так как после захода индекс секции может измениться.
Остановить загрузку items при переходе на другой экран и продолжить после возврата.

### Occasions
* [updateOccasions](https://github.com/dbystruev/Outfit-Selection/blob/master/Outfit%20Selection/App/AppDelegate/AppDelegate%2Bupdate.swift) - добавить timeout для ответа от сервера и загружать Occasions из кэша если timeout превышен
