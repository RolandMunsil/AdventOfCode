import strscans
import strutils
import strformat

type Lens = tuple[label: string, focal: int]
var boxes: array[256, seq[Lens]]

func hashLabel(label: string): uint8 =
    for ch in label: result = uint8((result.int + ch.int) * 17)

for step in readFile("input.txt").strip().split(","):
    if '=' in step:
        var lens: Lens
        discard step.scanf("$w=$i", lens.label, lens.focal)
        let pBox = boxes[hashLabel(lens.label)].addr

        block insertLens:
            for boxLens in pBox[].mitems:
                if boxLens.label == lens.label:
                    boxLens.focal = lens.focal
                    break insertLens
            
            pBox[].add lens
    else:
        var label: string
        discard step.scanf("$w-", label)
        let pBox = boxes[hashLabel(label)].addr

        for i in pBox[].low..pBox[].high:
            if pBox[][i].label == label:
                pBox[].delete i
                break

var focusPower = 0

for iBox, box in boxes:
    for iLens, lens in box:
        focusPower.inc (iBox + 1) * (iLens + 1) * lens.focal

echo focusPower