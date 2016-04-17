module Tests

extend Test::All;

public int main() {
   list[bool] results = [];


   results += testShouldParseEntityWithValues();

   results += testShouldParseEntityWithValuesAndAnnotations();

   results += testShouldParseEmptyEntityWithName();

   results += testShouldParseEmptyEntityWithModuleImports();

   results += testShouldParseTableNameAnnotationForEntity();

   results += testShouldParseIndexesAnnotationForEntity();

   results += testShouldParseCompositeAnnotationForEntity();

   results += testShouldParseModule();

   results += testShouldParseModuleWithUnderscoresInName();

   results += testShouldNotParseTwoModuleDeclarations();

   results += testShouldParseModuleWithImportFromOtherModule();

   results += testShouldParseModuleWithImportFromSameModule();

   results += testShouldParseModuleWithImportFromSameModuleWithAlias();

   results += testShouldParseModuleWithImportFromOtherModuleWithAlias();

   results += testShouldParseModuleWithCompositeImports();

   return false in results ? 1 : 0;
}
