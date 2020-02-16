from cpython cimport buffer
from libc.stdlib cimport realloc,free

from .khashsets cimport Int64Set, Int64Set_from_buffer, khint_t, kh_exist_int64set



cdef char *empty_buf=""

# responsible for freeing the data (so we are sure "right" free is called) and 
# can expose the data via buffer interface
# 
cdef class MemoryNanny:

    cdef void*       ptr
    cdef Py_ssize_t  n
    cdef Py_ssize_t  element_size
    cdef Py_ssize_t  buffer_lock_cnt
    cdef bytes       format

    def __cinit__(self):
        self.ptr = NULL
        self.n = 0
        self.element_size = 0
        self.buffer_lock_cnt = 0
        self.format = None 

    def __dealloc__(self):      
        free(self.ptr)
        self.ptr=NULL 

    def __getbuffer__(self, buffer.Py_buffer *view, int flags):
        #is input sane?
        if(view==NULL):
            raise BufferError("view==NULL argument is obsolete")


        #should never happen, just to be sure
        if NULL == self.ptr:
            view.buf = empty_buf
        else:
            view.buf = self.ptr

        view.obj = self; # increments ref count
       
        
        # size of the memory-block in bytes
        view.len = self.n * self.element_size

         
        # 0 or 1 possible as long as the same for all
        view.readonly = 0

        # should be original value, even if buffer.format is set to NULL
        view.itemsize = self.element_size;

        # format:
        if (flags & buffer.PyBUF_FORMAT) == buffer.PyBUF_FORMAT:
             view.format = self.format
        else:
             raise BufferError("PyBUF_FORMAT needed")

        # data is one-dimensional
        view.ndim = 1;
        

        view.shape = NULL
        view.strides = NULL
        view.suboffsets = NULL

        # no need for internal data
        view.internal = NULL

        self.buffer_lock_cnt+=1


    def __releasebuffer__(self, buffer.Py_buffer *view):
        self.buffer_lock_cnt-=1


    @staticmethod
    cdef MemoryNanny create_memory_nanny(void* ptr, Py_ssize_t  n, Py_ssize_t element_size, object format):
        cdef MemoryNanny nanny = MemoryNanny()
        nanny.ptr = ptr
        nanny.n   = n
        nanny.element_size = element_size
        nanny.format =  format
        return nanny




cpdef unique_int64(int64_t[:] vals, double size_hint=1.25):
    cdef Int64Set s = Int64Set_from_buffer(vals, size_hint)
    

    # compress:
    cdef int64_t* mem = s.table.keys
    cdef khint_t i
    cdef khint_t current = 0
    for i in range(s.table.n_buckets):
        if kh_exist_int64set(s.table, i):
            mem[current] = mem[i]
            current += 1

    # take over the memory:
    s.table.keys = NULL
    
    # shrink to fit:
    mem = <int64_t*> realloc(mem, sizeof(int64_t)*current);
    return MemoryNanny.create_memory_nanny(mem, current, sizeof(int64_t), b"q")


