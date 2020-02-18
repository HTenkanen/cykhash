
cdef class Float64to64Map:

    def __cinit__(self, size_hint=1, for_int64 = True):
        self.for_int64 = for_int64
        self.table = kh_init_float64to64map()
        if size_hint is not None:
            kh_resize_float64to64map(self.table, size_hint)

    def __len__(self):
        return self.size()
  
    cdef khint_t size(self):
        return self.table.size
        

    def __dealloc__(self):
        if self.table is not NULL:
            kh_destroy_float64to64map(self.table)
            self.table = NULL

    def __contains__(self, float64_t key):
        return self.contains(key)


    cdef bint contains(self, float64_t key) except *:
        cdef khint_t k
        k = kh_get_float64to64map(self.table, key)
        return k != self.table.n_buckets


    cpdef void put_int64(self, float64_t key, int64_t val) except *:
        cdef:
            khint_t k
            int ret = 0

        k = kh_put_float64to64map(self.table, key, &ret)
        self.table.keys[k] = key
        self.table.vals[k] = val

    cpdef void put_float64(self, float64_t key, float64_t val) except *:
        self.put_int64(key, f64_to_i64(val));

    
    def __setitem__(self, key, val):
        if self.for_int64:
            self.put_int64(key, val)
        else:
            self.put_float64(key, val)

    cpdef int64_t get_int64(self, float64_t key) except *:
        k = kh_get_float64to64map(self.table, key)
        if k != self.table.n_buckets:
            return self.table.vals[k]
        else:
            raise KeyError("No such key: "+str(key))

    cpdef float64_t get_float64(self, float64_t key) except *:
        return i64_to_f64(self.get_int64(key))

    def __getitem__(self, key):
        if self.for_int64:
            return self.get_int64(key)
        else:
            return self.get_float64(key)

    
    cpdef void discard(self, float64_t key) except *:
        cdef khint_t k
        k = kh_get_float64to64map(self.table, key)
        if k != self.table.n_buckets:
            kh_del_float64to64map(self.table, k)


    cdef Float64to64MapIterator get_iter(self):
        return Float64to64MapIterator(self)

    def __iter__(self):
        return self.get_iter()


### Iterator:
cdef class Float64to64MapIterator:

    cdef void __move(self) except *:
        while self.it<self.size and not kh_exist_float64to64map(self.parent.table, self.it):
              self.it+=1       

    cdef bint has_next(self) except *:
        return self.it != self.parent.table.n_buckets
        
    cdef float64to64_key_val_pair next(self) except *:
        cdef float64to64_key_val_pair result 
        result.key = self.parent.table.keys[self.it]
        result.val = self.parent.table.vals[self.it]
        self.it+=1#ensure at least one move!
        self.__move()
        return result


    def __cinit__(self, Float64to64Map parent):
        self.parent = parent
        self.size = parent.table.n_buckets
        #search the start:
        self.it = 0
        self.__move()

    def __next__(self):
        if self.has_next():
            return self.next()
        else:
            raise StopIteration

### Utils:

def Float64to64Map_from_int64_buffer(float64_t[:] keys, int64_t[:] vals, double size_hint = 1.25):
    cdef Py_ssize_t n = len(keys)
    cdef Py_ssize_t b = len(vals)
    if b < n:
        n = b
    cdef Py_ssize_t start_size = <Py_ssize_t>(n*size_hint)+1
    res=Float64to64Map(start_size)
    cdef Py_ssize_t i
    for i in range(n):
        res.put_int64(keys[i], vals[i])
    return res

def Float64to64Map_from_float64_buffer(float64_t[:] keys, float64_t[:] vals,double size_hint = 1.25):
    cdef Py_ssize_t n = len(keys)
    cdef Py_ssize_t b = len(vals)
    if b < n:
        n = b
    cdef Py_ssize_t start_size = <Py_ssize_t>(n*size_hint)+1
    res=Float64to64Map(start_size, False)
    cdef Py_ssize_t i
    for i in range(n):
        res.put_float64(keys[i], vals[i])
    return res
    

