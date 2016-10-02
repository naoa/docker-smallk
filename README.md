# Dockerfile for SmallK

Dockerfile for SmallK.

http://smallk.github.io/about/

https://github.com/smallk/smallk

>SmallK is a high performance software package for low rank matrix approximation via the nonnegative matrix factorization (NMF). Algorithms for NMF compute the low rank factors of a matrix producing two nonnegative matrices whose product approximates the original matrix.


# Usage

```
docker pull naoa/smallk
docker run --rm -v /var/lib/smallk:/var/lib/smallk naoa/smallk nmf --matrixfile /var/lib/smallk/news20.mtx --k 2 --outfile_W /var/lib/smallk/w.csv --outfile_H /var/lib/smallk/h.csv
```

``/var/lib/smallk/`` is shared folder.


There is testfile here.

https://github.com/smallk/smallk_data
