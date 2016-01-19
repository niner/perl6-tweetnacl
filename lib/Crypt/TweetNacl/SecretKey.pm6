use v6;
use NativeCall;
use LibraryMake;
use Crypt::TweetNacl::Constants;

unit module Crypt::TweetNacl::SecretKey;

=begin pod
=head1 NAME

	   Crypt::TweetNacl::SecretKey - secret key crypto library

=head1 SYNOPSIS


=head1 DESCRIPTION

=head1 OPTIONS

=head1 RETURN VALUE

   In case problems arise this is reported by an exception.

=head1 ERRORS


=head1 DIAGNOSTICS


=head1 EXAMPLES


=head1 ENVIRONMENT


=head1 FILES


=head1 CAVEATS

   Various other(not documented) classes and methods might be exported
   by the library. Please ignore them.

=head1 BUGS


=head1 RESTRICTIONS


=head1 NOTES


=head1 SEE ALSO

   - https://nacl.cr.yp.to/secretbox.html
   - https://tweetnacl.cr.yp.to/tweetnacl-20131229.pdf

=head1 AUTHOR

    Frank Hartmann

=head1 HISTORY


=end pod



DOC INIT {
        use Pod::To::Text;
        pod2text($=pod);
}

# C NaCl provides a crypto_secretbox function callable as follows:

#      #include "crypto_secretbox.h"

#      const unsigned char k[crypto_secretbox_KEYBYTES];
#      const unsigned char n[crypto_secretbox_NONCEBYTES];
#      const unsigned char m[...]; unsigned long long mlen;
#      unsigned char c[...]; unsigned long long clen;

#      crypto_secretbox(c,m,mlen,n,k);

# The crypto_secretbox function encrypts and authenticates a message
# m[0], m[1], ..., m[mlen-1] using a secret key k[0], ...,
# k[crypto_secretbox_KEYBYTES-1] and a nonce n[0], n[1], ...,
# n[crypto_secretbox_NONCEBYTES-1]. The crypto_secretbox function puts
# the ciphertext into c[0], c[1], ..., c[mlen-1]. It then returns 0.

# WARNING: Messages in the C NaCl API are 0-padded versions of
# messages in the C++ NaCl API. Specifically: The caller must ensure,
# before calling the C NaCl crypto_secretbox function, that the first
# crypto_secretbox_ZEROBYTES bytes of the message m are all 0. Typical
# higher-level applications will work with the remaining bytes of the
# message; note, however, that mlen counts all of the bytes, including
# the bytes required to be 0.
# Similarly, ciphertexts in the C NaCl API are 0-padded versions of
# messages in the C++ NaCl API. Specifically: The crypto_secretbox
# function ensures that the first crypto_secretbox_BOXZEROBYTES bytes
# of the ciphertext c are all 0.


sub crypto_secretbox_int (CArray[int8], CArray[int8], ulonglong, CArray[int8], CArray[int8]) is symbol('crypto_secretbox') is native(TWEETNACL) is export returns int32 { * };

# C NaCl also provides a crypto_secretbox_open function callable as follows:

#      #include "crypto_secretbox.h"

#      const unsigned char k[crypto_secretbox_KEYBYTES];
#      const unsigned char n[crypto_secretbox_NONCEBYTES];
#      const unsigned char c[...]; unsigned long long clen;
#      unsigned char m[...];

#      crypto_secretbox_open(m,c,clen,n,k);

# The crypto_secretbox_open function verifies and decrypts a
# ciphertext c[0], c[1], ..., c[clen-1] using a secret key k[0], k[1],
# ..., k[crypto_secretbox_KEYBYTES-1] and a nonce n[0], ...,
# n[crypto_secretbox_NONCEBYTES-1]. The crypto_secretbox_open function
# puts the plaintext into m[0], m[1], ..., m[clen-1]. It then returns
# 0.

# If the ciphertext fails verification, crypto_secretbox_open instead
# returns -1, possibly after modifying m[0], m[1], etc.

# The caller must ensure, before calling the crypto_secretbox_open
# function, that the first crypto_secretbox_BOXZEROBYTES bytes of the
# ciphertext c are all 0. The crypto_secretbox_open function ensures
# (in case of success) that the first crypto_secretbox_ZEROBYTES bytes
# of the plaintext m are all 0.

sub crypto_secretbox_open_int (CArray[int8], CArray[int8], ulonglong, CArray[int8], CArray[int8]) is symbol('crypto_secretbox_open') is native(TWEETNACL) is export returns int32 { * };
