; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+ssse3,+sse4a | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSSE3
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse4.2,+sse4a | FileCheck %s --check-prefix=ALL --check-prefix=SSE --check-prefix=SSE42
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx,+sse4a| FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+avx2,+sse4a | FileCheck %s --check-prefix=ALL --check-prefix=AVX --check-prefix=AVX2
;
; Combine tests involving SSE4A target shuffles (EXTRQI,INSERTQI)

declare <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8>, <16 x i8>)

define <16 x i8> @combine_extrqi_pshufb_16i8(<16 x i8> %a0) {
; ALL-LABEL: combine_extrqi_pshufb_16i8:
; ALL:       # BB#0:
; ALL-NEXT:    extrq {{.*#+}} xmm0 = xmm0[1,2],zero,zero,zero,zero,zero,zero,xmm0[u,u,u,u,u,u,u,u]
; ALL-NEXT:    retq
  %1 = shufflevector <16 x i8> %a0, <16 x i8> zeroinitializer, <16 x i32> <i32 1, i32 2, i32 16, i32 16, i32 16, i32 16, i32 16, i32 16, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 0, i8 1, i8 2, i8 3, i8 4, i8 255, i8 255, i8 255, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>)
  ret <16 x i8> %2
}

define <8 x i16> @combine_extrqi_pshufb_8i16(<8 x i16> %a0) {
; ALL-LABEL: combine_extrqi_pshufb_8i16:
; ALL:       # BB#0:
; ALL-NEXT:    extrq {{.*#+}} xmm0 = xmm0[2,3],zero,zero,zero,zero,zero,zero,xmm0[u,u,u,u,u,u,u,u]
; ALL-NEXT:    retq
  %1 = shufflevector <8 x i16> %a0, <8 x i16> zeroinitializer, <8 x i32> <i32 1, i32 2, i32 8, i32 8, i32 undef, i32 undef, i32 undef, i32 undef>
  %2 = bitcast <8 x i16> %1 to <16 x i8>
  %3 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %2, <16 x i8> <i8 0, i8 1, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>)
  %4 = bitcast <16 x i8> %3 to <8 x i16>
  ret <8 x i16> %4
}

define <16 x i8> @combine_insertqi_pshufb_16i8(<16 x i8> %a0, <16 x i8> %a1) {
; SSSE3-LABEL: combine_insertqi_pshufb_16i8:
; SSSE3:       # BB#0:
; SSSE3-NEXT:    extrq {{.*#+}} xmm1 = xmm1[0,1],zero,zero,zero,zero,zero,zero,xmm1[u,u,u,u,u,u,u,u]
; SSSE3-NEXT:    movdqa %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE42-LABEL: combine_insertqi_pshufb_16i8:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmovzxwq {{.*#+}} xmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero
; SSE42-NEXT:    retq
;
; AVX-LABEL: combine_insertqi_pshufb_16i8:
; AVX:       # BB#0:
; AVX-NEXT:    vpmovzxwq {{.*#+}} xmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero
; AVX-NEXT:    retq
  %1 = shufflevector <16 x i8> %a0, <16 x i8> %a1, <16 x i32> <i32 16, i32 17, i32 18, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %2 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %1, <16 x i8> <i8 0, i8 1, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>)
  ret <16 x i8> %2
}

define <8 x i16> @combine_insertqi_pshufb_8i16(<8 x i16> %a0, <8 x i16> %a1) {
; SSSE3-LABEL: combine_insertqi_pshufb_8i16:
; SSSE3:       # BB#0:
; SSSE3-NEXT:    extrq {{.*#+}} xmm1 = xmm1[0,1],zero,zero,zero,zero,zero,zero,xmm1[u,u,u,u,u,u,u,u]
; SSSE3-NEXT:    movdqa %xmm1, %xmm0
; SSSE3-NEXT:    retq
;
; SSE42-LABEL: combine_insertqi_pshufb_8i16:
; SSE42:       # BB#0:
; SSE42-NEXT:    pmovzxwq {{.*#+}} xmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero
; SSE42-NEXT:    retq
;
; AVX-LABEL: combine_insertqi_pshufb_8i16:
; AVX:       # BB#0:
; AVX-NEXT:    vpmovzxwq {{.*#+}} xmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero
; AVX-NEXT:    retq
  %1 = shufflevector <8 x i16> %a0, <8 x i16> %a1, <8 x i32> <i32 8, i32 1, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef>
  %2 = bitcast <8 x i16> %1 to <16 x i8>
  %3 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %2, <16 x i8> <i8 0, i8 1, i8 255, i8 255, i8 255, i8 255, i8 255, i8 255, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>)
  %4 = bitcast <16 x i8> %3 to <8 x i16>
  ret <8 x i16> %4
}

define <16 x i8> @combine_pshufb_insertqi_pshufb(<16 x i8> %a0, <16 x i8> %a1) {
; ALL-LABEL: combine_pshufb_insertqi_pshufb:
; ALL:       # BB#0:
; ALL-NEXT:    insertq {{.*#+}} xmm0 = xmm0[0],xmm1[0,1],xmm0[3,4,5,6,7,u,u,u,u,u,u,u,u]
; ALL-NEXT:    retq
  %1 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %a0, <16 x i8> <i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>)
  %2 = shufflevector <16 x i8> %1, <16 x i8> %a1, <16 x i32> <i32 0, i32 16, i32 17, i32 3, i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %3 = tail call <16 x i8> @llvm.x86.ssse3.pshuf.b.128(<16 x i8> %2, <16 x i8> <i8 7, i8 1, i8 2, i8 4, i8 3, i8 undef, i8 undef, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>)
  ret <16 x i8> %3
}
