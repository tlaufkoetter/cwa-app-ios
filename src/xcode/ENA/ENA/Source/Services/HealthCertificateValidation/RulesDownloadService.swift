//
// 🦠 Corona-Warn-App
//

import Foundation
import HealthCertificateToolkit
import class CertLogic.Rule

protocol RulesDownloadServiceProviding {
	func downloadRules(
		ruleType: HealthCertificateValidationRuleType,
		completion: @escaping (Result<[Rule], DCCDownloadRulesError>) -> Void
	)
}

class RulesDownloadService: RulesDownloadServiceProviding {
	
	// MARK: - Init

	init (
		restServiceProvider: RestServiceProviding
	) {
		self.restServiceProvider = restServiceProvider
	}
	
	// MARK: - Protocol RulesDownloadServiceProviding
	
	func downloadRules(
		ruleType: HealthCertificateValidationRuleType,
		completion: @escaping (Result<[Rule], DCCDownloadRulesError>) -> Void
	) {
		let resource = DCCRulesResource(ruleType: ruleType)
		restServiceProvider.load(resource) { result in
			switch result {
			case let .success(validationRulesModel):
				completion(.success(validationRulesModel.rules))
			case let .failure(error):
				guard let customError = resource.customError(for: error) else {
					Log.error("Unhandled error \(error.localizedDescription)", log: .vaccination)
					completion(.failure(.RULE_CLIENT_ERROR(ruleType)))
					return
				}
				completion(.failure(customError))
			}
		}
	}
	
	// MARK: - Private

	private let restServiceProvider: RestServiceProviding

}
