# SlidesKit (v0.1)
Slides is framework that allows you to control presentation slides files(.ppt, .pptx, .pdf) in iOS easily. One major component is SKSlidesView, it it a subclass of UIView. You could use it to display and control slides. Another major component is SKCacheManager, and it helps you to get metadata of all slides in the specified directory.
<br>
<br>
<br>

## SKSlidesView
To create it in interface builder, simply drag a view to your storyboard and set its custom class to SKSlidesView.
<br>To use it programmatically, use initializer```SKSlidesView(frame: CGRect)```
```Swift
let slidesView = SKSlidesView(frame: CGRectMake(0, 0, 400, 300))
```
<br>
- Set delegate to get callback
```Swift
class ViewController: UIViewController, SKSlidesViewDelegate {
    
    @IBOutlet weak var slidesView: SKSlidesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slidesView.delegate = self
    } 
}
```
<br>
- Callback for after slides finish loading
```Swift
func slidesViewDidFinishLoad(slidesView: SKSlidesView) {
    loadingIndicator.hidden = true
    slidesView.hidden = false
}
```
<br>
- Load Slides
```Swift
let filePath = /* filepath of your presentation slides */
slidesView.load(filePath)
```
<br>
- Go Through Slides
```Swift
let filePath = /* filepath of your presentation slides */
slidesView.nextPage()
slidesView.prevPage()
slidesView.firstPage()
slidesView.finalPage()
``` 
<br>

