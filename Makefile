APK_NAME=apk/base.apk
JAR_NAME=jar/app.jar
FRESH_DIR=original
DIRTY_DIR=decompiled
FRESH_DIR_BAK=original_temp
EXTRACTED_DIR=extracted
DIFF_DIR=diff

DEX2JAR_TOOL=tools/dex2jar/d2j-dex2jar.sh

$(DIRTY_DIR): $(FRESH_DIR)
	cp -r $(FRESH_DIR) $(DIRTY_DIR)
	patch -p1 --directory='$(DIRTY_DIR)' < diff/deobfuscation.diff

$(JAR_NAME):
	mkdir -p jar
	$(DEX2JAR_TOOL) $(APK_NAME) -o $(JAR_NAME)

$(EXTRACTED_DIR):
	mkdir -p $(EXTRACTED_DIR)
	java -jar tools/apktool_2.4.1.jar d $(APK_NAME)

$(FRESH_DIR): $(JAR_NAME)
	mkdir -p $(FRESH_DIR)
	java -jar tools/cfr-0.149.jar $(JAR_NAME) --outputdir $(FRESH_DIR)

.PHONY: $(DIFF_DIR)
$(DIFF_DIR):
	mkdir -p diff
	diff -Nau0r $(FRESH_DIR) $(DIRTY_DIR) > diff/deobfuscation.diff

.PHONY: clean
clean:
	rm -rf ./jar
	rm -rf ./$(FRESH_DIR)
	rm -rf ./$(DIRTY_DIR)
	rm -f ./base-error.zip
	rm -f ./summary.txt
	rm -rf ./$(EXTRACTED_DIR)
