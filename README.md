# GMTwerk 2

## Overview

GMTwerk 2 allows you to set delays, listen to conditions and animate values asynchronously using a fire-and-forget interface. One GMTwerk 2 actor can replace alarms, timelines and many kinds of step event code in a compact, at-source form. Focus on what you want to do, not how to continue it in future steps — and smooth out your animations with unprecedented ease along the way.

## Requirements

- GameMaker Studio 2.3.1+

## Installation

Get the current asset package and documentation from [the releases page](https://github.com/dicksonlaw583/GMTwerk2/releases). Simply extract everything to your project, including the host object and all accompanying class definitions.

Once you install the package, you may optionally change the options in `__GMTWERK_CONFIG__`. The defaults should be appropriate for most step-based setups.

## Quick Examples

### Execute an action after 1 second

```
Delay(1000, function() {
    show_message("Time's up!");
});
```

### Execute an action when a condition becomes satisfied

```
WhenTrue(function() {
    return bbox_top > room_height;
}, function() {
    show_message("You fell!");
});
```

### Animate a value and then execute an action

```
Tween(InstanceVar("image_alpha"), 0, 500, [
    "onDone", function() {
        instance_destroy();
    }
]);
```

