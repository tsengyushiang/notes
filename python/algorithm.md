# Algorithm

- compare string

    - source code 

        ```
        import difflib
        def compareString(groundTruth,OCR):
            s = difflib.SequenceMatcher(None, groundTruth, OCR)
            equalString = ""
            for tag, i1, i2, j1, j2 in s.get_opcodes():
                if(tag=='equal'):
                    equalString += groundTruth[i1:i2]
                    #print('{:7}   groundTruth[{}:{}] --> OCR[{}:{}] {!r:>8} --> {!r}'.format(tag, i1, i2, j1, j2, groundTruth[i1:i2], OCR[j1:j2]))

            return equalString
        ```
    - usage
        ```
        equalString = compareString(gtstring,ocrstring)
        ```