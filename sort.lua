-- note: only works in 0.2.1.
function sort(unsorted, comes_before)
     local t = {}
     for v in all(unsorted) do
         -- determine `insert_at` index.
         local insert_at = 1
         local slot = t[insert_at]
         while slot and comes_before(slot, v) do
             insert_at += 1
             slot = t[insert_at]
         end

         -- insert value at index.
         add(t, v, insert_at)
     end
     return t
end
