module DataFrameUtils
	using DataFrames
	using Iterators

	export combine!, mapcombinations

	# TODO: Make this work with AbstractDataFrames
	# TODO: Set names properly
	# TODO: Add error handling
	function combine!(accumulator::DataFrame,
		              names::Any,
		              combination::Any,
		              results::DataFrame)
		ntags = length(combination)
		nrows_res, ncols_res = size(results)
		nrows_out, ncols_out = nrows_res, ntags + ncols_res
		if size(accumulator, 1) == 0
			newcols = Array(Any, ncols_out)
			for j in 1:ntags
				newcols[j] = {}
				for i in 1:nrows_out
					push!(newcols[j], combination[j])
				end
			end
			for j in 1:ncols_res
				newcols[ntags + j] = {}
				for i in 1:nrows_out
					push!(newcols[ntags + j], results[i, j])
				end
			end
			accumulator.columns = newcols
			newnames = copy(names)
			append!(newnames, DataFrames.names(results))
			accumulator.colindex = DataFrames.Index(newnames)
			return
		else
			for j in 1:ntags
				for i in 1:nrows_out
					push!(accumulator.columns[j], combination[j])
				end
			end
			for j in 1:ncols_res
				for i in 1:nrows_out
					push!(accumulator.columns[ntags + j], results[i, j])
				end
			end
		end
		return
	end

	function combine!(accumulator::DataFrame,
		              names::Any,
		              combination::Any,
		              results::AbstractVector)
		ntags = length(combination)
		nrows_res, ncols_res = length(results), 1
		nrows_out, ncols_out = nrows_res, ntags + ncols_res
		if size(accumulator, 1) == 0
			newcols = Array(Any, ncols_out)
			for j in 1:ntags
				newcols[j] = {}
				for i in 1:nrows_out
					push!(newcols[j], combination[j])
				end
			end
			newcols[ntags + 1] = Array(eltype(results), 0)
			for i in 1:nrows_out
				push!(newcols[ntags + 1], results[i])
			end
			accumulator.columns = newcols
			newnames = copy(names)
			append!(newnames, DataFrames.gennames(1))
			accumulator.colindex = DataFrames.Index(newnames)
			return
		else
			for j in 1:ntags
				for i in 1:nrows_out
					push!(accumulator.columns[j], combination[j])
				end
			end
			for i in 1:nrows_out
				push!(accumulator.columns[ntags + 1], results[i])
			end
		end
		return
	end

	function combine!(accumulator::DataFrame,
		              names::Any,
		              combination::Any,
		              results::Any)
		# Check ndims(results)
		if ndims(results) != 0
			error("Attempted to combine a DataFrame with a mislabeled scalar")
		end
		ntags = length(combination)
		nrows_res, ncols_res = 1, 1
		nrows_out, ncols_out = nrows_res, ntags + ncols_res
		if size(accumulator, 1) == 0
			newcols = Array(Any, ncols_out)
			for j in 1:ntags
				newcols[j] = {}
				for i in 1:nrows_out
					push!(newcols[j], combination[j])
				end
			end
			newcols[ntags + 1] = Array(eltype(results), 0)
			push!(newcols[ntags + 1], results)
			accumulator.columns = newcols
			newnames = copy(names)
			append!(newnames, DataFrames.gennames(1))
			accumulator.colindex = DataFrames.Index(newnames)
			return
		else
			for j in 1:ntags
				for i in 1:nrows_out
					push!(accumulator.columns[j], combination[j])
				end
			end
			push!(accumulator.columns[ntags + 1], results)
		end
		return
	end

	function mapcombinations(f::Function; kwargs::Any...)
		nargs = length(kwargs)

		names = Array(Symbol, nargs)
		values = Array(Any, nargs)
		for i in 1:nargs
			names[i], values[i] = kwargs[i]
		end

		df = DataFrame()

		for args in product(values...)
			combine!(df, names, args, f(args...))
		end

		return df
	end
end
