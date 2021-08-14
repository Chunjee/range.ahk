class range {

	__New(start := 0, ending := 10, step := 1) {
		this.start := start
		this.ending := ending
		this.step := step
	}

	toArray() {
		arr := []
		provider := (this.step < 0) ? this._nEval.Bind(this) : this._pEval.Bind(this)
		if (!this.step) {
			return, arr
		}
		while(provider.Call((v := (A_Index - 1) * this.step + this.start), this.ending)) {
			arr.Push(v)
		}
		return, arr
	}

	_NewEnum() {
		return, new Range._enumProvider(this.start
										, this.ending
										, this.step
										, (this.step < 0)
											? this._nEval.Bind(this)
											: this._pEval.Bind(this))
	}

	_pEval(now, max) {
		return, now < max
	}

	_nEval(now, min) {
		return, now > min
	}

	class includingEnd extends range {
		_pEval(now, max) {
			return, now <= max
		}
		_nEval(now, min) {
			return, now >= min
		}
	}

	class _enumProvider {
		index := 0
		__New(start, ending, step, provider) {
			this.start := start
			this.ending := ending
			this.step := step
			this.provider := provider
		}
		Next(ByRef k:="", ByRef v:="") {
			v := this.index * this.step + this.start
			k := this.index + 1
			if(!this.step || !this.provider.Call(v, this.ending))
				return, 0
			this.index++
			return, 1
		}
	}
}
