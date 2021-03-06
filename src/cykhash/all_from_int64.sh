
SOURCE_DIR="sets/int64/"
SET_DIR="sets/"


### int32sets
echo "Creating int32set from int64set..."
TARGET_DIR=$SET_DIR/int32/
# mkdir -p $TARGET_DIR
cp $SOURCE_DIR/int64set_header.pxi  $TARGET_DIR/int32set_header.pxi
sed -i -- 's/64/32/g'   $TARGET_DIR/int32set_header.pxi
cp $SOURCE_DIR/int64set_impl.pxi    $TARGET_DIR/int32set_impl.pxi
sed -i -- 's/64/32/g'   $TARGET_DIR/int32set_impl.pxi


### float64set:
echo "Creating float64set from int64set..."
TARGET_DIR=$SET_DIR/float64/
# mkdir -p $TARGET_DIR
cp $SOURCE_DIR/int64set_header.pxi          $TARGET_DIR/float64set_header.pxi
sed -i -- 's/int64/float64/g'   $TARGET_DIR/float64set_header.pxi
sed -i -- 's/Int64/Float64/g'   $TARGET_DIR/float64set_header.pxi
cp $SOURCE_DIR/int64set_impl.pxi            $TARGET_DIR/float64set_impl.pxi
sed -i -- 's/int64/float64/g'   $TARGET_DIR/float64set_impl.pxi
sed -i -- 's/Int64/Float64/g'   $TARGET_DIR/float64set_impl.pxi


### float32set:
echo "Creating float32set from float64set..."
SOURCE_DIR_FLOAT64=$SET_DIR/float64/
TARGET_DIR=$SET_DIR/float32/
# mkdir -p $TARGET_DIR
cp $SOURCE_DIR_FLOAT64/float64set_header.pxi          $TARGET_DIR/float32set_header.pxi
sed -i -- 's/64/32/g'             $TARGET_DIR/float32set_header.pxi
cp $SOURCE_DIR_FLOAT64/float64set_impl.pxi            $TARGET_DIR/float32set_impl.pxi
sed -i -- 's/64/32/g'             $TARGET_DIR/float32set_impl.pxi

### pyobjectset:
#
#  pyobjectset is special, so it should not be used here
#
#echo "Creating pyobjectset from in64set..."
#cp int64set_header.pxi  pyobjectset_header.pxi
#sed -i -- 's/int64/pyobject/g'   pyobjectset_header.pxi
#sed -i -- 's/Int64/PyObject/g'   pyobjectset_header.pxi
#
#cp int64set_impl.pxi    pyobjectset_impl.pxi
#sed -i -- 's/int64/pyobject/g'   pyobjectset_impl.pxi
#sed -i -- 's/Int64/PyObject/g'   pyobjectset_impl.pxi


###  MAPS

SOURCE_DIR="maps/int64/"
MAP_DIR="maps/"


### int32map
echo "Creating int32map from int64map..."
TARGET_DIR=$MAP_DIR/int32/
# mkdir -p $TARGET_DIR
cp $SOURCE_DIR/int64to64map_header.pxi  $TARGET_DIR/int32to32map_header.pxi
sed -i -- 's/64/32/g'   $TARGET_DIR/int32to32map_header.pxi
cp $SOURCE_DIR/int64to64map_impl.pxi    $TARGET_DIR/int32to32map_impl.pxi
sed -i -- 's/64/32/g'   $TARGET_DIR/int32to32map_impl.pxi



SOURCE_DIR="maps/float64/"

### float32map
echo "Creating float32map from float64map..."
TARGET_DIR=$MAP_DIR/float32/
# mkdir -p $TARGET_DIR
cp $SOURCE_DIR/float64to64map_header.pxi  $TARGET_DIR/float32to32map_header.pxi
sed -i -- 's/64/32/g'   $TARGET_DIR/float32to32map_header.pxi
cp $SOURCE_DIR/float64to64map_impl.pxi    $TARGET_DIR/float32to32map_impl.pxi
sed -i -- 's/64/32/g'   $TARGET_DIR/float32to32map_impl.pxi



