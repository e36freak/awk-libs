## usage: fix_item(num)
## removes all non-alpha-numeric characters and leading zeroesfrom "num"
## then converts all letters to capital and returns the adjusted string
function fix_item(num) {
  gsub(/[^[:alnum:]]/, "", num);
  gsub(/^0+/, "", num);

  return toupper(num);
}
