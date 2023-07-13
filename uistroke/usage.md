# Scaling UIStroke objects

Roblox's engine currently does not support the scale option for UIStrokes hence only the Thickness property operates.

As everyone knows, it might irritate you to the point where you may confuse about what to do cross-devices while working with UI designers or people specialized in UX. It's one of them. It's the right spot here. You can scale the UIStroke objects with this plugin until the corresponding feature officially gets implemented.

## Understanding UIStroke

Basically, an 'Instance' used beneath 'GuiObject's to cover the interface with a stroke. It's based on pixels and not viewport size with a scale.

## Scaling

There are two types of scaling internally programmed in the plugin: UpperScale and LowerScale.
**UpperScale** is used in accordance with one UDim value if it is larger than the other dimension, whereas **LowerScale** is used with the one which is smaller than the other.
Both scale types are determined whenever the developer uses the "insert" and "delete" buttons, and as a result, the viewport size matters. This is the formula to compute:

```
UIStroke.Thickness / ViewportSize.X
UIStroke.Thickness / ViewportSize.Y
```

## Important to Note

When using the plugin to insert the attributes to UIStroke objects, consider your viewport size as it is significant for other developers -if they need to edit them- they also need to use the same viewport size.
