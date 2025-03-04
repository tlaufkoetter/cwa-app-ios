//
// 🦠 Corona-Warn-App
//

import Foundation
import HealthCertificateToolkit

struct ValidationOnboardedCountriesModel: CBORDecoding {


	static func decode(_ data: Data) -> Result<ValidationOnboardedCountriesModel, ModelDecodingError> {
		switch OnboardedCountriesAccess().extractCountryCodes(from: data) {
		case .success(let countryCodes):
			let countries = countryCodes.compactMap {
				Country(withCountryCodeFallback: $0)
			}
			return Result.success(ValidationOnboardedCountriesModel(countries: countries))
		case .failure(let error):
			return Result.failure(.CBOR_DECODING_ONBOARDED_COUNTRIES(error))
		}
	}

	private init(countries: [Country] ) {
		self.countries = countries
	}

	// MARK: - Internal

	let countries: [Country]
	
}
